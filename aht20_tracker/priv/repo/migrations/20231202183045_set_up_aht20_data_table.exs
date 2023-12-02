defmodule Aht20Tracker.Repo.Migrations.SetUpAht20DataTable do
  use Ecto.Migration

  def up do
    execute("CREATE EXTENSION IF NOT EXISTS timescaledb")

    create table(:aht20_conditions, primary_key: false) do
      add :timestamp, :naive_datetime, null: false
      add :temperature, :decimal, null: false
      add :humidity, :decimal, null: false
    end

    execute("SELECT create_hypertable('aht20_conditions', 'timestamp')")
  end

  def down do
    drop table(:aht20_conditions)
    execute("DROP EXTENSION IF EXISTS timescaledb")
  end
end
