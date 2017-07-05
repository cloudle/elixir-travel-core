defmodule Ace.PageController do
  use Ace.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

	def api(conn, params) do
	  account = (Guardian.Plug.current_resource(conn)) #User's account if logged in.

		{success, data} = GraphQL.execute_with_opts(
			Api.schema,
			params["query"],
			root_value: account || %{},
			variable_values: params["variables"],
      # validate: Mix.env != :prod #Only validate Schema on :dev | :test
			)

		case success do
			:ok -> json conn, data
			:error -> json conn, %{
				errors: Enum.map(data, fn error -> %{message: error} end)
			}
		end
	end
end
