defmodule Aht20Tracker.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Aht20TrackerWeb.Telemetry,
      Aht20Tracker.Repo,
      {DNSCluster, query: Application.get_env(:aht20_tracker, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Aht20Tracker.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Aht20Tracker.Finch},
      # Start a worker by calling: Aht20Tracker.Worker.start_link(arg)
      # {Aht20Tracker.Worker, arg},
      # Start to serve requests, typically the last entry
      Aht20TrackerWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Aht20Tracker.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    Aht20TrackerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
