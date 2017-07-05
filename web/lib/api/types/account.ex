defmodule Api.Types.Account do
	def type, do: %GraphQL.Type.ObjectType{
		name: "User",
		description: "User account, the most essential entry-point",
		fields: %{
			id: Api.Resolver.id,
			avatar: Api.Resolver.string,
			username: Api.Resolver.string,
			fullname: Api.Resolver.string,
			phone: Api.Resolver.string,
			email: Api.Resolver.string,
			idCardImage: Api.Resolver.string,
			token: Api.Resolver.string("Json web token for authenticated user."),
			creditNumber: Api.Resolver.string,
      creditExp: Api.Resolver.string,
		}
	}

end
