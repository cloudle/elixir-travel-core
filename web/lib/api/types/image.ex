defmodule Api.Types.Image do
	def type, do: %GraphQL.Type.ObjectType{
		name: "Image",
		description: "Image of a user",
		fields: %{
			id: Api.Resolver.id,
			url: Api.Resolver.string,
		}
	}

end
