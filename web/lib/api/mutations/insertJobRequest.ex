defmodule Api.Mutations.InsertJobRequest do
	def type, do: %{
		args: %{
			type: Api.Primitive.enum!(Api.Enum.jobRequestType),
			categoryId: Api.Primitive.int!,
			longitude: Api.Primitive.float!,
			latitude: Api.Primitive.float!,
			address: Api.Primitive.string!,
			price: Api.Primitive.float!,
			description: Api.Primitive.string,
			notice: Api.Primitive.string,
			workTime: Api.Primitive.string,
			deposit: Api.Primitive.string,
			time: Api.Primitive.string,
			tags: Api.Primitive.listOfString,
		},
		resolve: {__MODULE__, :insert},
	} |> Api.Mutation.new(Api.Types.JobRequest)

	def insert(_, args, %{root_value: %{id: userId}}) do
	  price = if (args[:price] < 10) do 10 else args[:price] end
	  tags = Poison.encode! Map.get(args, :tags, [])
	  request = args
	    |> Map.put(:price, price)
	    |> Map.delete(:type)
	    |> Map.delete(:tags)

    query = """
      MATCH (user:Account), (category:JobCategory)
      WHERE ID(user) = #{userId} AND ID(category) = #{args[:categoryId]}
      CREATE (user)-[:#{args[:type]}]->(n:JobRequest #{Cypher.objectStatement(request)})<-[:PARENT]-(category)
      FOREACH (tagName IN #{tags} | MERGE (t:Tag{name: tagName}) CREATE (n)-[:HAS_TAG]->(t))
      WITH n CALL spatial.addNode('geom',n) YIELD node
      RETURN node
    """

		with {:ok, result} <- Cypher.first("node", query),
			do: %{payload: result}
	end

	def insert(_, _, _), do: raise "Un-authorized connection!"

end
