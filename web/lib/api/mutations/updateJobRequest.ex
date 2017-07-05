defmodule Api.Mutations.UpdateJobRequest do
	def type, do: %{
		args: %{
			id: Api.Primitive.int!,
			categoryId: Api.Primitive.int,
			longitude: Api.Primitive.float,
			latitude: Api.Primitive.float,
			address: Api.Primitive.string,
			price: Api.Primitive.int,
			description: Api.Primitive.string,
			notice: Api.Primitive.string,
			workTime: Api.Primitive.string,
			deposit: Api.Primitive.string,
			time: Api.Primitive.string,
			tags: Api.Primitive.listOfString,
		},
		resolve: {__MODULE__, :update},
	} |> Api.Mutation.new(Api.Types.JobRequest)

	def update(_, args, %{root_value: %{id: userId}}) do
	  price = if (args[:price] < 10) do 10 else args[:price] end
	  tags = Poison.encode! Map.get(args, :tags, [])
    updateOpts = args
      |> Map.put(:price, price)
      |> Map.delete(:tags)

    query = """
      START request=NODE(#{args[:id]}), owner=NODE(#{userId})
      MATCH (user)-[r1:REGISTER|REQUEST]->(request)
      #{Cypher.setStatement(updateOpts, "request")}
      FOREACH (tagName IN #{tags} | MERGE (request)-[:HAS_TAG]->(:Tag{name: tagName}))
      RETURN request
    """

		with {:ok, result} <- Cypher.first("request", query, %{}, "You may not the owner of the Request!"),
			do: %{payload: result}
	end

  def update(_, _, _), do: raise "Un-authorized connection!"
end
