defmodule KotkowoWeb.NewsLive.PassedAway do
  @moduledoc false

  use KotkowoWeb, :live_view

  import KotkowoWeb.Components.Static.HowYouCanHelpSection

  alias Kotkowo.Client
  alias Kotkowo.Client.Cat
  alias Kotkowo.Client.Image
  alias Kotkowo.Client.Paged

  require Logger

  defp parse_int_param(nil), do: nil
  defp parse_int_param(page) when is_integer(page), do: page

  defp parse_int_param(page) when is_binary(page) do
    case Integer.parse(page) do
      {page, _rest} -> page
      _ -> nil
    end
  end

  @impl true
  def handle_async(:load_cats, {:ok, cats}, socket) do
    socket =
      case cats do
        {:ok, %Paged{items: cats, page_count: page_count, page_size: page_size, page: page, total: total}} ->
          params = %{page: page, page_size: page_size}
          # NOTE: page_count = 0, page = 1 for no results when filtered
          page_count = max(1, page_count)

          if page <= page_count do
            socket
            |> stream(:cats, cats, reset: true)
            |> assign(:cats_total, total)
            |> assign(:page_count, page_count)
            |> assign(:params, params)
          else
            push_navigate(socket, to: ~p"/aktualnosci/za-teczowym-mostem")
          end

        {:error, msg} ->
          Logger.error(msg)
          socket
      end

    {:noreply, socket}
  end

  @impl true
  def mount(params, _session, socket) do
    initial_filter = Cat.Filter.from_params(params["cat"])
    socket = socket |> assign(:initial_filter, initial_filter) |> stream(:cats, []) |> assign(:params, nil)
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    filter = Cat.Filter.from_params(params["cat"])
    dead_filter = Map.put(filter, :is_dead, true)
    page_size = params |> Map.get("page_size", "30") |> parse_int_param()
    page = params |> Map.get("page") |> parse_int_param()

    socket =
      start_async(socket, :load_cats, fn ->
        [page: page, page_size: page_size, filter: dead_filter] |> Client.new() |> Client.list_cats()
      end)

    {:noreply, socket}
  end

  @impl true
  def handle_info({:filter_cat, %Cat.Filter{} = filter}, socket) do
    socket = push_patch(socket, to: ~p"/aktualnosci/za-teczowym-mostem" <> "?#{Cat.Filter.to_params(filter)}")
    {:noreply, socket}
  end

  defp items_per_page, do: [30, 60, 90]

  def pagination_bar(assigns) do
    assigns =
      assigns
      |> assign(:previous_page, assigns.selected_page - 1)
      |> assign(:next_page, assigns.selected_page + 1)
      |> assign(:first_page, 1)

    ~H"""
    <div class="flex flex-row text-xl gap-x-4">
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
