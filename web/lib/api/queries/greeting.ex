defmodule Api.Queries.Greeting do
  def type, do: %{
		type: %GraphQL.Type.String{},
		resolve: {__MODULE__, :greeting}
	}

	def greeting(_, _, %{root_value: %{id: userId}}) do
	  query = ~s[START user=NODE(#{userId}) RETURN user]

	  with {:ok, %{properties: %{"fullname" => username}}} <- Cypher.first("user", query),
	    do: "Welcome back, #{username}"
  end
	def greeting(_, _, _), do: "Welcome strager"
end
