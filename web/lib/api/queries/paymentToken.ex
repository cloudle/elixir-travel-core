defmodule Api.Queries.PaymentToken do
  def type, do: %{
    type: %GraphQL.Type.String{},
    resolve: {__MODULE__, :generate}
  }

  def generate(_, _, %{root_value: %{id: _}}) do
    with {:ok, token} <- Braintree.ClientToken.generate,
      do: token
  end

  def generate(_, _, _), do: raise "Un-authenticated request!"
end
