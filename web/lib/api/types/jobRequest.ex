defmodule Api.Types.JobRequest do
	def type, do: %GraphQL.Type.ObjectType{
		name: "JobRequest",
		description: "Job's request from Traveller",
		fields: %{
			id: Api.Resolver.id,
			type: Api.Resolver.string,
			description: Api.Resolver.string,
			price: Api.Resolver.string,
			time: Api.Resolver.string,
			notice: Api.Resolver.string,
			workTime: Api.Resolver.string,
			latitude: Api.Resolver.float,
			longitude: Api.Resolver.float,
			address: Api.Resolver.string,
			tags: %{
			  type: %GraphQL.Type.List{ofType: %GraphQL.Type.String{}},
        description: "Tags for searching jobs",
        resolve: {Api.Resolvers.Tag, :fromRequest},
			},
			category: %{
			  type: Api.Types.JobCategory,
			  resolve: {Api.Resolvers.JobCategory, :fromRequest},
			},
			worker: %{
			  type: Api.Types.Account,
			  resolve: {Api.Resolvers.Account, :workerFromRequest}
			},
			traveller: %{
			  type: Api.Types.Account,
        resolve: {Api.Resolvers.Account, :travellerFromRequest}
			},
		}
	}
end
