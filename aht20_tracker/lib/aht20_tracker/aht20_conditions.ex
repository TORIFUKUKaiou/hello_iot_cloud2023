defmodule Aht20Tracker.Aht20Conditions do
  alias Aht20Tracker.{
    Repo,
    Aht20Conditions.Aht20Condition
  }

  def create_entry(attrs) do
    %Aht20Condition{} |> Aht20Condition.create_changeset(attrs) |> Repo.insert()
  end
end
