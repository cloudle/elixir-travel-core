defmodule Api.Mutations.InsertJobTransact do
	def type, do: %{
		args: %{
		  categoryId: Api.Primitive.int!,
      registrationId: Api.Primitive.int!,
      price: Api.Primitive.float!,
      time: Api.Primitive.string!,
      nonce: Api.Primitive.string!,
		},
		resolve: {__MODULE__, :insert},
	} |> Api.Mutation.new(Api.Types.JobTransact)

	def insert(_, args, %{root_value: %{id: userId}}) do
    transact = args
      |> Map.put(:requestorId, userId)
	    |> Map.put(:status, "INVITE")

    with {:ok, transaction} <- payment(args[:price], args[:nonce]),
         transact <- transact |> Map.put(:paymentId, transaction.id),
         query <- buildQuery(transact, args, userId),
         {:ok, transact} <- Cypher.first("transact", query)
      do
       %{payload: transact}
     else
      error ->
        IO.inspect error
        raise "Some error, check NONCE."
     end

#    registrationQuery = ~s[
#      START registration=NODE(#{args[:registrationId]})
#      WHERE registration:JobRequest RETURN registration]
#    workerQuery = ~s[
#      START worker=NODE(#{args[:workerId]})
#      WHERE worker:Account RETURN worker]
#
#		with {:ok, _registration} <- Cypher.first("registration", registrationQuery),
#		     {:ok, _worker} <- Cypher.first("worker", workerQuery),
#		     {:ok, _request} <- Cypher.delete("JobRequest", args[:requestId], userId),
#         {:ok, result} <- Cypher.insert("JobTransact", transact),
#      do: %{payload: result}
	end

	def insert(_, _, _), do: raise "Un-authorized connection!"

  def payment(amount, nonce) do
    Braintree.Transaction.sale %{
      amount: amount,
      payment_method_nonce: nonce,
    }
  end

  def buildQuery(transact, args, userId) do
    """
      START
        traveller=NODE(#{userId}),
        registration=NODE(#{args[:registrationId]}),
        category=NODE(#{args[:categoryId]})
      MATCH (worker:Account)-[:REGISTER]->(registration:JobRequest)<-[:PARENT]-(category:JobCategory)
      CREATE (traveller)-[:REQUEST]->(transact:JobTransact #{Cypher.objectStatement(transact)})-[:INVITED{status: "SEND"}]->(registration)
      CREATE (category)-[:PARENT]->(transact)
      RETURN transact
    """
  end
end
