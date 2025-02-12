defmodule KotkowoWeb.AnnouncementsLive.AllNews do
  @moduledoc false
  use KotkowoWeb, :live_view

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
          if page > page_count do
            params = %{limit: limit, page: page_count}
            push_patch(socket, to: ~p"/aktualnosci/z-ostatniej-chwili/wszystkie?#{params}", replace: true)
          else
            socket
            |> stream(:news, news)
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

  attr :selected_page, :integer, required: true
  attr :last_page, :integer, required: true

  def pagination_bar(assigns) do
    assigns =
      assigns
      |> assign(:previous_page, assigns.selected_page - 1)
      |> assign(:next_page, assigns.selected_page + 1)
      |> assign(:first_page, @first_page)

    ~H"""
    <div class="flex flex-row text-xl gap-x-4 text-lg">
      <button
        :if={@selected_page != @first_page}
        phx-click="select_page"
        class="p-4"
        value={@selected_page - 1}
      >
        <.icon class=" rotate-90 brightness-0" name="chevron_down" />
      </button>

      <.icon :if={@selected_page == @first_page} class="rotate-90 p-4 grayscale" name="chevron_down" />
      <div class="self-center gap-4 hidden lg:inline">
        <button :if={@selected_page > 2} class="w-14 h-14" phx-click="select_page" value={@first_page}>
          <%= @first_page %>
        </button>
        <span :if={@selected_page > 2} class="w-14 h-14">...</span>
        <button
          :if={@selected_page != @first_page}
          class="w-14 h-14"
          phx-click="select_page"
          value={@previous_page}
        >
          <%= @previous_page %>
        </button>
        <button class="font-bold w-14 h-14">
          <%= @selected_page %>
        </button>
        <button
          :if={@selected_page != @last_page}
          class="w-14 h-14"
          phx-click="select_page"
          value={@next_page}
        >
          <%= @next_page %>
        </button>
        <span :if={@selected_page < @last_page - 1} class="w-14 h-14">...</span>

        <button
          :if={@selected_page < @last_page - 1}
          class="w-14 h-14"
          phx-click="select_page"
          value={@last_page}
        >
          <%= @last_page %>
        </button>
      </div>
      <div class="self-center flex flex-row lg:hidden gap-4">
        <span><%= @selected_page %></span>
        <span>z</span>
        <span><%= @last_page %></span>
      </div>
      <.icon :if={@selected_page == @last_page} class="rotate-90 p-4 grayscale" name="chevron_up" />

      <button
        :if={@selected_page != @last_page}
        class="p-4"
        phx-click="select_page"
        value={@selected_page + 1}
      >
        <.icon class="rotate-90 brightness-0" name="chevron_up" />
      </button>
    </div>
    """
  end
end
