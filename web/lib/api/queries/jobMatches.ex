defmodule Api.Queries.JobMatches do
  def type, do: %{
    type: Api.Type.list(Api.Types.JobRequest),
    args: %{
      latitude: Api.Primitive.float!("Match's central latitude"),
      longitude: Api.Primitive.float!("Match's central longitude"),
      jobCategoryId: Api.Primitive.int!,
      distance: Api.Primitive.int,
      tags: Api.Primitive.listOfString,
    },
    resolve: {__MODULE__, :matches}
  }

  def matches(_, args, %{root_value: %{id: userId}}) do
    distance = Map.get(args, :distance, 200)
    tags = Poison.encode! Map.get(args, :tags, [])
    tagPredicate = if tags == "[]" do "" else "WHERE ANY (tag IN #{tags} WHERE (node)-[:HAS_TAG]->(:Tag))" end

    query = """
      CALL spatial.withinDistance('geom', {lon:#{args[:longitude]},lat:#{args[:latitude]}}, #{distance}) YIELD node
      MATCH (category:JobCategory) WHERE ID(category) = #{args[:jobCategoryId]}
      MATCH (traveller:Account) WHERE ID(traveller) = #{userId}
      MATCH (category)-[:PARENT]->(node:JobRequest)<-[:REGISTER]-(worker:Account)
      #{tagPredicate}
      WHERE NOT (traveller)-[:REGISTER]->(node) OR (traveller)-[:DISLIKE]->(worker)
      RETURN node
    """

    with {:ok, response} <- Cypher.all("node", query),
      do: response
  end

  def matches(_, _, _), do: [] #empty result for un-authoried connection!
end
