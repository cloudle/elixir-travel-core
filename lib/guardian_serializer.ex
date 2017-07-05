defmodule Ace.GuardianSerializer do
  @behaviour Guardian.Serializer

  def for_token(%{id: id}), do: {:ok, "user:#{id}"}
  def for_token(_), do: {:error, "unknown resource type"}

  def from_token("user:" <> userId) do
    with {integerId, _} <- Integer.parse userId do
      {:ok, %{id: integerId}}
    end
  end

  def from_token(_), do: { :error, "unknown resource type" }
end
