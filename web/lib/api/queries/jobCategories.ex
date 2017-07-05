defmodule Api.Queries.JobCategories do
	def type, do: %{
		type: Api.Type.list(Api.Types.JobCategory),
		resolve: {__MODULE__, :list}
	}

	def list(_, _, _) do
		with {:ok, response} <- Cypher.all("category", ~s[MATCH (category:JobCategory) RETURN category]),
		  do: response
	end
end
