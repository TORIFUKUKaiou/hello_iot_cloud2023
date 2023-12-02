defmodule Publisher do
  use GenServer
  require Logger

  def start_link(options \\ %{}) do
    GenServer.start_link(__MODULE__, options, name: __MODULE__)
  end

  @impl true
  def init(options) do
    state = %{
      interval: options[:interval] || 10_000,
      aht20_tracker_url: options[:aht20_tracker_url],
      measurements: :no_measurements
    }

    schedule_next_publish(state.interval)
    {:ok, state}
  end

  defp schedule_next_publish(interval) do
    Process.send_after(self(), :publish_data, interval)
  end

  @impl true
  def handle_info(:publish_data, state) do
    {:noreply, state |> measure() |> publish()}
  end

  defp measure(state) do
    AHT20.read()
    |> measure(state)
  end

  defp measure({:ok, measurements}, state) do
    Map.merge(state, %{measurements: measurements})
  end

  defp measure(_, state) do
    state
  end

  defp publish(state) do
    result =
      Req.post(state.aht20_tracker_url, state.measurements)

    Logger.debug("Server response: #{inspect(result)}")
    schedule_next_publish(state.interval)
    state
  end
end
