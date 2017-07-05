defmodule Api.Mutations.DeleteJobRequest do
	def type, do: %{
		args: %{
			id: Api.Primitive.int!,
		},
		resolve: {__MODULE__, :delete},
	} |> Api.Mutation.new(Api.Types.JobRequest)

	def delete(_, %{id: requestId}, %{root_value: %{id: userId}}) do
		query = """
      START user=NODE(#{userId}), request=NODE(#{requestId})
      MATCH (user:Account)-[r1]->(request)<-[r2]-(:JobCategory)
      MATCH (request)<-[r3:RTREE_REFERENCE]-()
      DELETE r1, r2, r3, request
      RETURN request
    """

		with {:ok, result} <- Cypher.first("request", query),
			do: %{payload: result}
	end

  def delete(_, _, _), do: raise "Un-authorized connection!"
end
