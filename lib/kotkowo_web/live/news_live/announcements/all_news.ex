defmodule KotkowoWeb.AnnouncementsLive.AllNews do
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
      |> stream(:news, [])
      |> assign(:max_page, @first_page)
      |> assign(:page, @first_page)
      |> assign(:limit, @default_limit)

    {:ok, socket}
  end

  @impl true
  def handle_async(:load_announcements, {:ok, {announcements, page}}, socket) do
    socket =
      case announcements do
        {:ok, %Paged{items: news, page_count: page_count, page_size: limit}} ->
          cond do
            page_count == 0 ->
              socket
              |> stream(:news, news)
              |> assign(:page, @first_page)
              |> assign(:limit, limit)
              |> assign(:max_page, @first_page)

            page > page_count ->
              params = %{limit: limit, page: page_count}
              push_patch(socket, to: ~p"/aktualnosci/z-ostatniej-chwili/wszystkie?#{params}", replace: true)

            true ->
              socket
              |> stream(:news, news)
              |> assign(:page, page)
              |> assign(:limit, limit)
              |> assign(:max_page, page_count)
          end

        {:error, msg} ->
          Logger.error(msg)
          put_flash(socket, :error, "Błąd podczas wczytywania aktualności")
      end

    {:noreply, socket}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    limit = params |> Map.get("limit", Integer.to_string(@default_limit)) |> String.to_integer()
    page = params |> Map.get("page", Integer.to_string(@first_page)) |> String.to_integer() |> max(@first_page)

    socket =
      start_async(socket, :load_announcements, fn ->
        {[page: page, page_size: limit] |> Client.new() |> Client.list_announcements(), page}
      end)

    {:noreply, socket}
  end

  @impl true
  def handle_event("items_amount", %{"items_per_page" => amount}, socket) do
    limit = String.to_integer(amount)
    params = %{limit: limit, page: socket.assigns.page}

    socket =
      push_patch(socket, to: ~p"/aktualnosci/z-ostatniej-chwili/wszystkie?#{params}", replace: true)

    {:noreply, socket}
  end

  @impl true
  def handle_event("select_page", %{"value" => page}, socket) do
    params = %{page: page, limit: socket.assigns.limit}
    socket = push_patch(socket, to: ~p"/aktualnosci/z-ostatniej-chwili/wszystkie?#{params}", replace: true)
    {:noreply, socket}
  end

  defp items_per_page, do: [30, 60, 90]
end
