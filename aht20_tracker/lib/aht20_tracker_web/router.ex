defmodule Aht20TrackerWeb.Router do
  use Aht20TrackerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", Aht20TrackerWeb do
    pipe_through :api
  end

  # Enable Swoosh mailbox preview in development
  if Application.compile_env(:aht20_tracker, :dev_routes) do

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
