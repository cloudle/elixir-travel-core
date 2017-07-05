defmodule Api.Queries.JobRequests do
  def type, do: %{
    type: Api.Type.list(Api.Types.JobRequest),
    args: %{
      type: Api.Primitive.enum!(Api.Enum.jobRequestType),
    },
    resolve: {__MODULE__, :list}
  }

  def list(_, %{type: requestType}, %{root_value: %{type: "admin"}}) do
    query = """
      MATCH (:Account)-[:#{requestType}]->(request:JobRequest)
      RETURN request
    """

    with {:ok, response} <- Cypher.all("request", query, %{type: requestType}),
      do: response
  end

  def list(_, %{type: requestType}, %{root_value: %{id: userId}}) do
    query = """
      START user=NODE(#{userId})
      MATCH (user:Account)-[:#{requestType}]->(request:JobRequest)
      RETURN request
    """

    with {:ok, response} <- Cypher.all("request", query, %{type: requestType}),
      do: response
  end

  def list(_, _, _), do: [] #empty result for un-authoried connection!
end
