defmodule Api.Mutations.UpdateJobTransact do
	def type, do: %{
		args: %{
			id: Api.Primitive.int!,
			status: Api.Primitive.enum!(Api.Enum.jobTransactCommand),
      star: Api.Primitive.int,
      comment: Api.Primitive.string,
		},
		resolve: {__MODULE__, :update},
	} |> Api.Mutation.new(Api.Types.JobTransact)

  def update(_, args = %{status: "CANCEL"}, %{root_value: %{id: userId}}), do: update(args, userId)
  def update(_, args = %{status: "CONFIRM"}, %{root_value: %{id: userId}}), do: update(args, userId)
  def update(_, args = %{status: "COMMENT"}, %{root_value: %{id: userId}}), do: update_worker_comment(args, userId)
  def update(_, args, _), do: raise "Un-authorized connection!"

	def update(args, userId) do
	  updateOpts = args |> Map.delete(:id)

	  query = """
      START transact=NODE(#{args[:id]}), user=NODE(#{userId})
      MATCH (user:Account)-[:REQUEST]->(transact:JobTransact)
      #{Cypher.setStatement(updateOpts, "transact")}
      RETURN transact
    """

		with {:ok, result} <- Cypher.first("transact", query),
			do: %{payload: result}
  end

  def update_worker_comment(args, workerId) do
    updateOpts = %{
      workerComment: args[:comment],
      workerStar: args[:star],
    }

    query = """
      START transact=NODE(#{args[:id]}), user=NODE(#{workerId})
      MATCH (transact:JobTransact)-[:INVITED]->(:JobRequest)<-[:REGISTER]-(user:Account)
      #{Cypher.setStatement(updateOpts, "transact")}
      RETURN transact
    """

    with {:ok, result} <- Cypher.first("transact", query),
      do: %{payload: result}
  end
end
