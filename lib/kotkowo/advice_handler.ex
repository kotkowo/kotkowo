defmodule Kotkowo.AdviceHandler do
  @moduledoc false
  use GenServer

  alias Kotkowo.Client.Opts
  alias Kotkowo.Client.Pagination

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(_args) do
    send(self(), :fetch_advice)
    {:ok, nil}
  end

  def handle_call(:get_advice, _from, nil) do
    advice = get_advice()
    {:reply, advice, advice}
  end

  def handle_call(:get_advice, _from, state) do
    {:reply, state, state}
  end

  def handle_info(:fetch_advice, advice) do
    GenServer.cast(__MODULE__, :fetch_advice)
    {:noreply, advice}
  end

  def handle_cast(:fetch_advice, _state) do
    advice = get_advice()
    Process.send_after(self(), :fetch_advice, 60_000 * 5)
    {:noreply, advice}
  end

  defp get_advice,
    do:
      Kotkowo.Client.list_advices(%Opts{
        filter: nil,
        pagination: %Pagination{limit: 5, start: 0, page: nil, page_size: nil},
        sort: ["updatedAt:desc"]
      })
end
