defmodule Api.Mutation do
	def new(opts, payload_type) do
		args = Map.merge(Map.get(opts, :args, %{}), %{
			clientMutationId: Api.Primitive.string,
		})

		Map.merge opts, %{
			args: args,
			type: %GraphQL.Type.ObjectType{
				name: "#{payload_type.type.name}MutationPayload",
				fields: %{
					clientMutationId: Api.Resolver.string,
					payload: %{type: payload_type},
				}
			}
		}
	end
end
