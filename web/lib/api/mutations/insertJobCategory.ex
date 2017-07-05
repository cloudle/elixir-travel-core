defmodule Api.Mutations.InsertJobCategory do
	def type, do: %{
		args: %{
			title: Api.Primitive.string,
			enabled: Api.Primitive.boolean,
		},
		resolve: {__MODULE__, :insert},
	} |> Api.Mutation.new(Api.Types.JobCategory)

	def insert(_, args, _) do
		with {:ok, result} <- Cypher.insert("JobCategory", args),
			do: %{payload: result}
	end

	def insert(_, _, _), do: raise "Un-authorized connection!"

end
