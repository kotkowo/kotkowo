defmodule KotkowoWeb.NewsLive.AllNews do
  @moduledoc false
  use KotkowoWeb, :live_view

  import KotkowoWeb.Components.PaginationBar

  alias Kotkowo.StrapiClient

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    limit = params |> Map.get("limit", "30") |> String.to_integer()
    page = params |> Map.get("page", "1") |> String.to_integer()

    offset = (page - 1) * limit
    {:ok, news} = StrapiClient.list_announcements(limit, offset)

    socket =
      socket
      |> assign(:news, news)
      |> assign(:page, page)
      |> assign(:limit, limit)

    {:noreply, socket}
  end

  @impl true
  def handle_event("items_amount", %{"items_per_page" => amount}, socket) do
    limit = String.to_integer(amount)
    params = %{limit: limit, page: socket.assigns.page}
    socket = push_patch(socket, to: ~p"/aktualnosci/z-ostatniej-chwili/wszystkie?#{params}")

    {:noreply, socket}
  end

  @impl true
  def handle_event("select_page", %{"value" => page}, socket) do
    params = %{page: page, limit: socket.assigns.limit}
    socket = push_patch(socket, to: ~p"/aktualnosci/z-ostatniej-chwili/wszystkie?#{params}")
    {:noreply, socket}
  end
end
