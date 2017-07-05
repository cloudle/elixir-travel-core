defmodule Api.Enum do
  def jobRequestType, do: %{
    name: "JobRequestType",
    values: %{
      "JobRegistration": %{value: "REGISTER"},
      "JobRequest": %{value: "REQUEST"},
    }
  } |>  GraphQL.Type.Enum.new

  def accountType, do: %{
    name: "AccountType",
    values: %{
      "Traveller": %{value: "TRAVELLER"},
      "Worker": %{value: "WORKER"},
    }
  } |> GraphQL.Type.Enum.new

  def jobTransactStatus, do: %{
    name: "JobTransactStatus",
    values: %{
      "Invite": %{value: "INVITE"},
      "Cancel": %{value: "CANCEL"},
      "Confirm": %{value: "CONFIRM"},
      "History": %{value: "HISTORY"},
      "Comment": %{value: "COMMENT"},
    }
  } |> GraphQL.Type.Enum.new

  def jobTransactCommand, do: %{
    name: "JobTransactCommand",
    values: %{
      "Cancel": %{value: "CANCEL"},
      "Confirm": %{value: "CONFIRM"},
      "Comment": %{value: "COMMENT"},
    }
  } |> GraphQL.Type.Enum.new

end