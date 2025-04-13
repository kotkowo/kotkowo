defmodule Kotkowo.Plausible.ViewPuller do
  @moduledoc false
  use GenServer

  require Logger

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(args) do
    Logger.info("Started view puller")
    {:ok, args, {:continue, :startup}}
  end

  def handle_continue(:startup, state) do
    send(self(), :update)
    {:noreply, state}
  end

  def handle_info(:update, [interval: interval] = state) do
    case Kotkowo.Plausible.update_article_views() do
      {:ok, true} ->
        :ok

      {:error, reason} ->
        reason |> inspect() |> Logger.error()
    end

    Process.send_after(self(), :update, interval)
    {:noreply, state}
  end
end
