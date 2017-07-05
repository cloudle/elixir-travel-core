defmodule Api.Resolvers.JobRequest do
  def fromTransact(transact, _, _) do
      query = """
        START transact=NODE(#{transact.id})
        MATCH (transact:JobTransact)-[:INVITED]->(request:JobRequest)
        RETURN request LIMIT 1
      """

      with {:ok, request} <- Cypher.first("request", query),
        do: request
    end
end