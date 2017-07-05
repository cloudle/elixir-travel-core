defmodule Api.Mutations.InsertAccount do
	def type, do: %{
		args: %{
			username: Api.Primitive.string!,
			password: Api.Primitive.string!,
			fullname: Api.Primitive.string,
			phone: Api.Primitive.string,
			email: Api.Primitive.string,
			avatar: Api.Primitive.string,
			token: Api.Primitive.string,
			creditNumber: Api.Primitive.string,
			creditExp: Api.Primitive.string,
		},
		resolve: {__MODULE__, :insert},
	} |> Api.Mutation.new(Api.Types.Account)

	def insert(_, args, _) do
		account = args
			|> Map.put(:hash, Comeonin.Bcrypt.hashpwsalt(args[:password]))
			|> Map.delete(:password)

		with {:ok, response} <- Cypher.insert("Account", account),
				 {:ok, jwt, _} <- Guardian.encode_and_sign(%{ id: response.id }, :token)
			do
				response = %Bolt.Sips.Types.Node{
					id: response.id,
					labels: response.labels,
					properties: Map.put(response.properties, "token", jwt)
				}

				%{payload: response}
			else
				status ->
				  IO.inspect status
				  raise "Unknown bug when inserting account (Neo4j connection or Guardian parser)"
			end

	end
end
