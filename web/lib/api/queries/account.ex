defmodule Api.Queries.Account do
	def type, do: %{
		type: Api.Types.Account,
		args: %{
			username: Api.Primitive.string,
		},
		resolve: {__MODULE__, :get}
	}

	@doc """
	Query single user from root;
	 params: [username]
	"""
	def get(_, %{username: username}, _) do
	  statement = ~s[MATCH (account:Account{username: $username}) RETURN account LIMIT 1]

		with {:ok, account} <- Cypher.first("account", statement, %{username: username}),
			do: account
	end

	def get(_, _, %{root_value: %{id: userId}}) do
	  statement = ~s[START account=NODE(#{userId}) RETURN account]

    with {:ok, account} <- Cypher.first("account", statement),
      do: account
	end
end
