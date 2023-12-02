defmodule Aht20TrackerWeb.Aht20ConditionsController do
  use Aht20TrackerWeb, :controller

  require Logger

  alias Aht20Tracker.{
    Aht20Conditions,
    Aht20Conditions.Aht20Condition
  }

  def create(conn, params) do
    IO.inspect(params)

    case Aht20Conditions.create_entry(params) do
      {:ok, aht20_condition = %Aht20Condition{}} ->
        Logger.debug("Successfully created a aht20 condition entry")

        conn
        |> put_status(:created)
        |> json(aht20_condition)

      error ->
        Logger.warn("Failed to create a aht20 entry: #{inspect(error)}")

        conn
        |> put_status(:unprocessable_entity)
        |> json(%{message: "Poorly formatted payload"})
    end
  end
end
