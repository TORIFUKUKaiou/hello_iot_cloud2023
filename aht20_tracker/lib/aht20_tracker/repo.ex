defmodule Aht20Tracker.Repo do
  use Ecto.Repo,
    otp_app: :aht20_tracker,
    adapter: Ecto.Adapters.Postgres
end
