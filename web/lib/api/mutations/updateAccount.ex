defmodule Api.Mutations.UpdateAccount do
	def type, do: %{
		args: %{
		  password: Api.Primitive.string,
      fullname: Api.Primitive.string,
      phone: Api.Primitive.string,
      email: Api.Primitive.string,
      idCardImage: Api.Primitive.string,
      avatar: Api.Primitive.string,
      creditNumber: Api.Primitive.string,
      creditExp: Api.Primitive.string,
		},
		resolve: {__MODULE__, :update},
	} |> Api.Mutation.new(Api.Types.Account)

	def update(_, args, %{root_value: %{id: userId}}) do
	  updateOpts = args |> Map.put(:id, userId)

	  with {:ok, result} <- Cypher.update("Account", updateOpts),
	    do: %{payload: result}
	end

  def update(_, _, _), do: raise "Un-authorized connection!"
end
