defmodule KotkowoWeb.AdviceLive.AllAdvices do
  @moduledoc false
  use KotkowoWeb, :live_view

  import KotkowoWeb.Components.Pagination
  import KotkowoWeb.Components.Static.HowYouCanHelpSection

  alias Kotkowo.Client
  alias Kotkowo.Client.Paged

  require Logger

  @first_page 1
  @default_limit 30

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> stream(:advices, [])
      |> assign(:max_page, @first_page)
      |> assign(:page, @first_page)
      |> assign(:limit, @default_limit)

    {:ok, socket}
  end

  @impl true
  def handle_async(:load_advices, {:ok, {advices, page}}, socket) do
    socket =
      case advices do
        {:ok, %Paged{items: advices, page_count: page_count, page_size: limit}} ->
          if page > page_count do
            params = %{limit: limit, page: page_count}
            push_patch(socket, to: ~p"/porady/wszystkie?#{params}", replace: true)
          else
            socket
            |> stream(:advices, advices)
            |> assign(:page, page)
            |> assign(:limit, limit)
            |> assign(:max_page, page_count)
          end

        {:error, msg} ->
          Logger.error(msg)
          socket
      end

    {:noreply, socket}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    limit = params |> Map.get("limit", Integer.to_string(@default_limit)) |> String.to_integer()
    page = params |> Map.get("page", Integer.to_string(@first_page)) |> String.to_integer()

    socket =
      start_async(socket, :load_advices, fn ->
        {[page: page, page_size: limit] |> Client.new() |> Client.list_advices(), page}
      end)

    {:noreply, socket}
  end

  @impl true
  def handle_event("items_amount", %{"items_per_page" => amount}, socket) do
    limit = String.to_integer(amount)
    params = %{limit: limit, page: socket.assigns.page}

    socket =
      push_patch(socket, to: ~p"/porady/wszystkie?#{params}", replace: true)

    {:noreply, socket}
  end

  @impl true
  def handle_event("select_page", %{"value" => page}, socket) do
    params = %{page: page, limit: socket.assigns.limit}
    socket = push_patch(socket, to: ~p"/porady/wszystkie?#{params}", replace: true)
    {:noreply, socket}
  end

  defp items_per_page, do: [30, 60, 90]
end
