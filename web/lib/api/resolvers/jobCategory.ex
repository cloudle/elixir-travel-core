defmodule Api.Resolvers.JobCategory do
  def fromRequest(request, _, _) do
    query = """
      START request=NODE(#{request.id})
      MATCH (category:JobCategory)-[:PARENT]->(request:JobRequest)
      RETURN category LIMIT 1
    """

    with {:ok, category} <- Cypher.first("category", query),
      do: category
  end

  def fromTransact(transact, _, _) do
      query = """
        START transact=NODE(#{transact.id})
        MATCH (category:JobCategory)-[:PARENT]->(transact:JobTransact)
        RETURN category LIMIT 1
      """

      with {:ok, category} <- Cypher.first("category", query),
        do: category
    end
end