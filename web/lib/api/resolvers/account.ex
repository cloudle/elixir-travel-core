defmodule Api.Resolvers.Account do
  def travellerFromTransact(transact, _, _) do
    query = """
      START transact=NODE(#{transact.id})
      MATCH (account:Account)-[:REQUEST]->(transact:JobTransact)
      RETURN account LIMIT 1
    """

    with {:ok, category} <- Cypher.first("account", query),
      do: category
  end

  def workerFromTransact(transact, _, _) do
    query = """
      START transact=NODE(#{transact.id})
      MATCH (transact:JobTransact)-[:INVITED]->(:JobRequest)<-[:REGISTER]-(account:Account)
      RETURN account LIMIT 1
    """

    with {:ok, category} <- Cypher.first("account", query),
      do: category
  end

  def travellerFromRequest(request, _, _) do
    query = """
      START request=NODE(#{request.id})
      MATCH (account:Account)-[:REQUEST]->(request:JobRequest)
      RETURN account LIMIT 1
    """

    with {:ok, category} <- Cypher.first("account", query),
      do: category
  end

  def workerFromRequest(request, _, _) do
    query = """
      START request=NODE(#{request.id})
      MATCH (account:Account)-[:REGISTER]->(request:JobRequest)
      RETURN account LIMIT 1
    """

    with {:ok, category} <- Cypher.first("account", query),
      do: category
  end
end