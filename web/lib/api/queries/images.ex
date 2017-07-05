defmodule Api.Queries.Images do
  def type, do: %{
    type: Api.Type.list(Api.Types.Image),
    resolve: {__MODULE__, :list}
  }

  def list(_, _, %{root_value: %{id: userId}}) do
    query = """
      START user=NODE(#{userId})
      MATCH (user:Account)-[:PARENT]->(image:Image)
      RETURN image
    """

    with {:ok, response} <- Cypher.all("image", query),
      do: response
  end

  def list(_, _, _), do: [] #empty result for un-authoried connection!
end
