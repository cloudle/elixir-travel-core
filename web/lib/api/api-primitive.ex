defmodule Api.Primitive do
	alias GraphQL.Type.String
	alias GraphQL.Type.Int
	alias GraphQL.Type.Float
	alias GraphQL.Type.Boolean
	alias GraphQL.Type.NonNull
	alias GraphQL.Type.List

	def string(description \\ "Self descriptive."), do: %{
		type: %String{},
		description: description,
	}

	def string!(description \\ "Self descriptive."), do: %{
		type: %NonNull{ofType: %String{}},
		description: description,
	}

	def int(description \\ "Self descriptive."), do: %{
		type: %Int{},
		description: description,
	}

	def int!(description \\ "Self descriptive."), do: %{
		type: %NonNull{ofType: %Int{}},
		description: description,
	}

	def float(description \\ "Self descriptive."), do: %{
		type: %Float{},
		description: description,
	}

	def float!(description \\ "Self descriptive."), do: %{
		type: %NonNull{ofType: %Float{}},
		description: description,
	}

	def boolean(description \\ "Self descriptive."), do: %{
		type: %Boolean{},
		description: description,
	}

	def enum(type, description \\ "Waiting for description..."), do: %{
	  type: type,
	  description: description,
	}

	def enum!(type, description \\ "Waiting for description..."), do: %{
    type: %NonNull{ofType: type},
    description: description,
	}

	def listOfString(description \\ "Self descriptive."), do: %{
	  type: %List{ofType: %String{}},
	  description: description,
	}

end

defmodule Api.Type do

	def list(type), do: %GraphQL.Type.List{ofType: type}
end
