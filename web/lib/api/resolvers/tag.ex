defmodule Api.Resolvers.Tag do
  def fromRequest(request, _, _) do
    query = """
      START request=NODE(#{request.id})
      MATCH (request:JobRequest)-[:HAS_TAG]->(tags:Tag)
      RETURN tags
    """

    for tag <- Cypher.all("tags", query), into: [], do: tag.properties["name"]
  end
end