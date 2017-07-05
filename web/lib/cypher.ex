defmodule Cypher do

	def query(statement, params \\ %{}) do
		Bolt.Sips.query(Bolt.Sips.conn, statement, params)
	end

	@doc """
	Query and Get first item from Cypher
	"""
	def first(type, statement, params \\ %{}, emptyMessage \\ "Document not found") do
		with {:ok, [result | _]} <- query(statement, params),
				 {:ok, response} <- Map.fetch(result, type)
			do {:ok, response}
			else
				{:ok, []} -> raise emptyMessage
        {:error, [{_, code}, {_, message}]} -> raise ~s(#{code}: #{type} #{message})
				_ -> raise "Some error accurred"
			end
	end

	@doc """
	Query and Get list of items from Cypher
	"""
	def all(type, statement, params \\ %{}) do
		with {:ok, results} <- query(statement, params),
				 response <- Enum.map(results, fn item -> Map.get(item, type) end)
			do response
			else
			  {:error, [{_, code}, {_, message}]} -> raise ~s(#{code}: #{type} #{message})
				_ -> raise "Some error accurred on Cypher's all.."
			end
	end

	# TODO: Optimize load on Production mode (single read only).
	def load(name) do
	  File.read!("./cyphers.json")
	  	|> to_string
	  	|> Poison.decode!
	  	|> Map.get(name)
	end

	@doc """
	Shorthand Cypher's simple Insert.
	"""
	def insert(type, instance) do
		first("instance", ~s[CREATE (instance:#{type} #{objectStatement(instance)}) RETURN instance])
	end

	@doc """
	Shorthand Cypher's single Update.
  """
  def update(type, opts = %{id: id}, ownerId, ownerKey \\ "ownerId") do
    opts = opts |> Map.delete(:id)

    updateStatement = ~s[
      START instance=NODE(#{id}), owner=NODE(#{ownerId})
      WHERE instance:#{type} AND instance.#{ownerKey} = #{ownerId}
      #{setStatement(opts)}
      RETURN instance]

    first("instance", updateStatement, %{}, "No update was made, you may not the owner of this #{type}")
  end

  def update(type, opts = %{id: id}) do
    updateStatement = ~s[
      START instance=NODE(#{id})
      WHERE instance:#{type}
      #{setStatement(opts)}
      RETURN instance]

    first("instance", updateStatement, %{}, "No update was made, make sure the #{type} exist!")
  end

  def delete(type, id, ownerId, ownerKey \\ "ownerId") do
    deleteStatement = ~s[
      START instance=NODE(#{id})
      WHERE instance:#{type} AND instance.#{ownerKey} = #{ownerId}
      DELETE instance RETURN instance]

    first("instance", deleteStatement, "Nothing deleted, you may not the owner of this #{type}")
  end

  def delete(type, id) do
    deleteStatment = ~s[START instance=NODE(#{id}) WHERE instance:#{type} DELETE instance RETURN instance]
    first("instance", deleteStatment, "Nothing deleted, make sure the #{type} exist!")
  end

  def begin,    do: Bolt.Sips.begin(Bolt.Sips.conn)
  def commit,   do: Bolt.Sips.commit(Bolt.Sips.conn)
  def rollback, do: Bolt.Sips.rollback(Bolt.Sips.conn)

	@doc """
  Generate Cypher's SET (string) statment from Elixir map.
  """
  def setStatement(source, instance \\ "instance") when is_map(source) do
    (for {key, value} <- source, value != nil,
      into: "SET ", do: generate_assignment({key, value}, instance))
      |> String.slice(0..-3)
  end

  def setStatement(_, _), do: ""

  defp generate_assignment({key, value}, instance) when is_binary(value), do: ~s(#{instance}.#{key} = "#{value}", )
  defp generate_assignment({key, value}, instance) when is_list(value), do: ~s(#{instance}.#{key} = #{Poison.encode!(value)}, )
  defp generate_assignment({key, value}, instance), do: ~s(#{instance}.#{key} = #{value}, )

	@doc """
	Generate Cypher Object statment (string) from Elixir Map.
	"""
	def objectStatement(source) when is_map(source) do
		(for {key, value} <- source, value != nil,
			into: "{", do: generate_attribute({key, value}))
			|> String.slice(0..-3) |> add_closing_brace
	end

	def objectStatement(_), do: "{}"

	defp generate_attribute({key, value}) when is_binary(value), do: ~s(#{key}: "#{value}", )
	defp generate_attribute({key, value}) when is_list(value), do: ~s(#{key}: #{Poison.encode!(value)}, )
	defp generate_attribute({key, value}), do: ~s(#{key}: #{value}, )
	defp add_closing_brace(source), do: ~s(#{source}})
end
