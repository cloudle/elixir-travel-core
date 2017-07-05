defmodule Api.Types.JobTransact do
	def type, do: %GraphQL.Type.ObjectType{
		name: "JobTransact",
		description: "Work <=> Job transact between two account (on progress or closed)",
		fields: %{
      id: Api.Resolver.id,
      description: Api.Resolver.string,
      price: Api.Resolver.int,
      time: Api.Resolver.string,
      status: Api.Resolver.string("[ON_PROGRESS, PAID, REFUND, REQUEST_REFUND]"),
      paymentId: Api.Resolver.string,
      star: Api.Resolver.int,
      comment: Api.Resolver.string,
      workerStar: Api.Resolver.int,
      workerComment: Api.Resolver.string,
      traveller: %{
        type: Api.Types.Account,
        resolve: {Api.Resolvers.Account, :travellerFromTransact},
      },
      worker: %{
        type: Api.Types.Account,
        resolve: {Api.Resolvers.Account, :workerFromTransact},
      },
      category: %{
        type: Api.Types.JobCategory,
        resolve: {Api.Resolvers.JobCategory, :fromTransact},
      },
      registration: %{
        type: Api.Types.JobRequest,
        resolve: {Api.Resolvers.JobRequest, :fromTransact},
      },
		}
	}
end
