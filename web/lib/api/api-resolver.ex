defmodule Api.Resolver do

	@doc"""
	Id type
	"""
	def id(description \\ "Identifier of a document."), do: %{
		type: %GraphQL.Type.String{},
		description: description,
		resolve: {__MODULE__, :resolve_id}
	}

	@doc"""
	String type
	"""
	def string(description \\ "Self descriptive."), do: %{
		type: %GraphQL.Type.String{},
		description: description,
		resolve: {__MODULE__, :resolve},
	}

	@doc"""
	Int type
	"""
	def int(description \\ "Self descriptive."), do: %{
		type: %GraphQL.Type.Int{},
		description: description,
		resolve: {__MODULE__, :resolve},
	}


	@doc"""
	Float type
	"""
	def float(description \\ "Self descriptive."), do: %{
		type: %GraphQL.Type.Float{},
		description: description,
		resolve: {__MODULE__, :resolve},
	}

	@doc"""
	Boolean
	"""
	def boolean(description \\ "Self descriptive."), do: %{
		type: %GraphQL.Type.Boolean{},
		description: description,
		resolve: {__MODULE__, :resolve},
	}

	@doc"""
  List of string
  """
  def listOfString(description \\ "Self descriptive."), do: %{
    type: %GraphQL.Type.List{ofType: %GraphQL.Type.String{}},
    description: description,
    resolve: {__MODULE__, :resolve},
  }

	@doc"""
	JSON type
	"""
	def json_of(type, description \\ "Child json of this document, self descriptive."), do: %{
		type: type,
		description: description,
		resolve: {__MODULE__, :resolve}
	}

	def resolve_id(obj, _, _), do: obj.id

	def resolve(obj, _, %{field_name: field}) do
		Map.get(obj.properties, to_string(field))
	end
end
