defmodule Api.Mutations.DeleteJobTransact do
	def type, do: %{
		args: %{
			id: Api.Primitive.int!,
		},
		resolve: {__MODULE__, :delete},
	} |> Api.Mutation.new(Api.Types.JobTransact)

	def delete(_, %{id: requestId}, %{root_value: %{id: userId}}) do
		with {:ok, result} <- Cypher.delete("JobTransact", requestId, userId),
			do: %{payload: result}
	end

  def delete(_, _, _), do: raise "Un-authorized connection!"
end
