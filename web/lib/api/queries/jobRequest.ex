defmodule Api.Queries.JobRequest do
  def type, do: %{
    type: Api.Types.JobRequest,
    args: %{
      id: Api.Primitive.int!,
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
