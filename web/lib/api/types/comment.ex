#defmodule Api.Types.Comment do
#	def type, do: %GraphQL.Type.ObjectType{
#		name: "Comment",
#		description: "A comment by user!",
#		fields: %{
#			id: Api.Resolver.id,
#			content: Api.Resolver.string,
#			owner: %{
#        type: Api.Types.Account,
#        resolve: {Api.Resolvers.JobCategory, :fromRequest},
#			},
#			transact: %{
#        type: Api.Types.JobTransact,
#        resolve: {Api.Resolvers.JobCategory, :fromRequest},
#			}
#		}
#	}
#
#end
