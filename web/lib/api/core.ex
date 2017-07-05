defmodule Api do
	def schema do
		%GraphQL.Schema{
			query: query(),
			mutation: mutation(),
		}
	end

	def query, do: %GraphQL.Type.ObjectType{
		name: "Queries",
		fields: %{
			greeting: Api.Queries.Greeting.type,
			user: Api.Queries.Account.type,
			jobCategories: Api.Queries.JobCategories.type,
			jobRequest: Api.Queries.JobRequest.type,
			jobRequests: Api.Queries.JobRequests.type,
			jobTransacts: Api.Queries.JobTransacts.type,
			jobMatches: Api.Queries.JobMatches.type,
			paymentToken: Api.Queries.PaymentToken.type,
			images: Api.Queries.Images.type,
		}
	}

	def mutation, do: %GraphQL.Type.ObjectType{
		name: "Mutations",
		fields: %{
			login: Api.Mutations.Login.type,
			insertAccount: Api.Mutations.InsertAccount.type,
			updateAccount: Api.Mutations.UpdateAccount.type,
			insertJobCategory: Api.Mutations.InsertJobCategory.type,
			insertJobRequest: Api.Mutations.InsertJobRequest.type,
			updateJobRequest: Api.Mutations.UpdateJobRequest.type,
			deleteJobRequest: Api.Mutations.DeleteJobRequest.type,
			insertJobTransact: Api.Mutations.InsertJobTransact.type,
			updateJobTransact: Api.Mutations.UpdateJobTransact.type,
			deleteJobTransact: Api.Mutations.DeleteJobTransact.type,
			insertImage: Api.Mutations.InsertImage.type,
		}
	}
end
