defmodule Api.Mutations.InsertImage do
	def type, do: %{
		args: %{
			url: Api.Primitive.string!,
		},
		resolve: {__MODULE__, :insert},
	} |> Api.Mutation.new(Api.Types.Image)

	def insert(_, args, %{root_value: %{id: userId}}) do
	  query = """
	    START user=NODE(#{userId})
      CREATE (user)-[:PARENT]->(image:Image #{Cypher.objectStatement(args)})
      RETURN image
    """

		with {:ok, result} <- Cypher.first("image", query),
			do: %{payload: result}
	end

	def insert(_, _, _), do: raise "Un-authorized connection!"

end
