defmodule Aht20Tracker.Aht20Conditions.Aht20Condition do
  use Ecto.Schema
  import Ecto.Changeset

  @allowed_fields [
    :temperature,
    :humidity
  ]
  @derive {Jason.Encoder, only: @allowed_fields}
  @primary_key false
  schema "aht20_conditions" do
    field :timestamp, :naive_datetime
    field :temperature, :decimal
    field :humidity, :decimal
  end

  def create_changeset(aht20_condition = %__MODULE__{}, attrs) do
    timestamp =
      NaiveDateTime.utc_now()
      |> NaiveDateTime.truncate(:second)

    aht20_condition
    |> cast(attrs, @allowed_fields)
    |> validate_required(@allowed_fields)
    |> put_change(:timestamp, timestamp)
  end
end
