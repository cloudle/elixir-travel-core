defmodule Api.Queries.Tag do
  def type, do: %{
    type: Api.Types.Tag,
    args: %{
      name: Api.Primitive.string!,
    },
    resolve: {__MODULE__, :get}
  }

  def get(_, %{id: id}, _) do
    statement = ~s[
      START request=NODE(#{id})
      WHERE request:JobRequest
      RETURN request LIMIT 1]

    with {:ok, response} <- Cypher.first("request", statement),
      do: response
  end
end
