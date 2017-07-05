defmodule Api.Mutations.Login do
	def type, do: %{
		args: %{
			username: Api.Primitive.string!,
			password: Api.Primitive.string,
		},
		resolve: {__MODULE__, :login}
	} |> Api.Mutation.new(Api.Types.Account)

	def login(_, args, _) do
		params = %{username: args[:username]}
		statement = ~s[MATCH (account:Account{username: $username}) RETURN account LIMIT 1]

		with {:ok, account = %{id: userId, properties: %{"hash" => hash}}} <- Cypher.first("account", statement, params),
				 true <- Comeonin.Bcrypt.checkpw(args[:password], hash),
				 {:ok, jwt, _} <- Guardian.encode_and_sign(%{id: userId}, :token)
			do
				response = %Bolt.Sips.Types.Node{
					id: account.id,
					labels: account.labels,
					properties: Map.put(account.properties, "token", jwt)
				}

				%{payload: response}
			else
				{:ok, _} 					-> raise "User account in wrong structure, it may created outside and wasn't supported."
				{:error, message} -> raise "Guardian encoder says: #{message}"
				false 						-> raise "Authencation was not correct."
				_ 								-> raise "Unknown bug from login (Comeonin's checkpw or Guardian's sign)"
			end
			
	end
end
