defmodule Api.Queries.JobTransacts do
	def type, do: %{
		type: Api.Type.list(Api.Types.JobTransact),
		args: %{
		  accountType: Api.Primitive.enum!(Api.Enum.accountType),
		  status: Api.Primitive.enum(Api.Enum.jobTransactStatus),
		},
		resolve: {__MODULE__, :list}
	}

	def list(_, args = %{accountType: accountType}, %{root_value: %{id: userId}}) do
    status = Map.get(args, :status, "INVITE")
    queryCondition = case args[:status] do
      "CONFIRM" -> ~s[WHERE transact.status = "CONFIRM"]
      "CANCEL" -> ~s[WHERE transact.status = "CANCEL"]
      "HISTORY" -> ~s[WHERE NOT transact.status = "INVITE"]
      _ -> ~s[WHERE transact.status = "INVITE"]
    end

    query = case accountType do
      "WORKER" -> """
        START worker=NODE(#{userId})
        MATCH (transact:JobTransact)-[:INVITED]->(:JobRequest)<-[:REGISTER]-(worker)
        #{queryCondition}
        RETURN transact
        """
      "TRAVELLER" -> """
        START traveller=NODE(#{userId})
        MATCH (traveller)-[:REQUEST]-(transact:JobTransact)
        #{queryCondition}
        RETURN transact
        """
      _ -> raise "#{accountType} type not supported!"
    end

		with {:ok, response} <- Cypher.all("transact", query),
		  do: response
	end

	def list(_, _, _), do: [] #empty result for un-authoried connection!
end
