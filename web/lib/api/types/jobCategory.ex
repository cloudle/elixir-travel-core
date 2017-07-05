defmodule Api.Types.JobCategory do
	def type, do: %GraphQL.Type.ObjectType{
		name: "JobCategory",
		description: "Job's category managed by admin",
		fields: %{
			id: Api.Resolver.id,
			title: Api.Resolver.string,
			enabled: Api.Resolver.boolean,
		}
	}
end
