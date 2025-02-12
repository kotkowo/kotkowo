defmodule KotkowoWeb.AdoptionLive.LookingForNewHome do
  @moduledoc false
  use KotkowoWeb, :live_view

  import KotkowoWeb.Components.Static.HowYouCanHelpSection
  import KotkowoWeb.Constants

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
  def handle_async(:load_unowned_cats, {:ok, cats}, socket) do
    socket =
      case cats do
        {:ok, %Paged{items: unowned_cats, page_count: page_count, page_size: page_size, page: page, total: total}} ->
          params = %{page: page, page_size: page_size}
          # NOTE: page_count = 0, page = 1 for no results when filteredcat_filt
          page_count = max(1, page_count)

          if page <= page_count do
            socket
            |> stream(:unowned_cats, unowned_cats, reset: true)
            |> assign(:unowned_cats_total, total)
            |> assign(:unowned_page_count, page_count)
            |> assign(:unowned_params, params)
          else
            push_navigate(socket, to: ~p"/adopcja/szukaja-domu")
          end

        {:error, msg} ->
          Logger.error(msg)
          socket
      end

    {:noreply, socket}
  end

  @impl true
  def handle_async(:load_owned_cats, {:ok, cats}, socket) do
    socket =
      case cats do
        {:ok, %Paged{items: owned_cats, page_count: page_count, page_size: page_size, page: page, total: total}} ->
          params = %{page: page, page_size: page_size}
          # NOTE: page_count = 0, page = 1 for no results when filtered
          page_count = max(1, page_count)

          if page <= page_count do
            socket
            |> stream(:owned_cats, owned_cats, reset: true)
            |> assign(:owned_cats_total, total)
            |> assign(:owned_page_count, page_count)
            |> assign(:owned_params, params)
          else
            push_navigate(socket, to: ~p"/adopcja/szukaja-domu")
          end

        {:error, msg} ->
          Logger.error(msg)
          socket
      end

    {:noreply, socket}
  end

  @impl true
  def mount(params, _session, socket) do
    initial_owned_filter = Cat.Filter.from_params(params["owned_cat"])
    initial_unowned_filter = Cat.Filter.from_params(params["unowned_cat"])

    socket =
      socket
      |> assign(:initial_owned_filter, initial_owned_filter)
      |> assign(:initial_unowned_filter, initial_unowned_filter)
      |> stream(:owned_cats, [])
      |> assign(:owned_cats_total, 0)
      |> assign(:owned_params, nil)
      |> stream(:unowned_cats, [])
      |> assign(:unowned_cats_total, 0)
      |> assign(:unowned_params, nil)

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    owned_filter = params["owned_cat"] |> Cat.Filter.from_params() |> Map.put(:is_dead, false)
    unowned_filter = params["unowned_cat"] |> Cat.Filter.from_params() |> Map.put(:is_dead, false)

    owned_page_size = params |> Map.get("owned_page_size", "30") |> parse_int_param()

    owned_page = params |> Map.get("owned_page") |> parse_int_param()

    unowned_page_size = params |> Map.get("unowned_page_size", "30") |> parse_int_param()

    unowned_page = params |> Map.get("unowned_page") |> parse_int_param()

    # NOTE: add section for cats not owned by kotkowo.
    socket =
      socket
      |> assign(:owned_filter, owned_filter)
      |> assign(:unowned_filter, unowned_filter)
      |> start_async(:load_owned_cats, fn ->
        [page: owned_page, page_size: owned_page_size, filter: owned_filter]
        |> Client.new()
        |> Client.list_looking_for_adoption_cats(true)
      end)
      |> start_async(:load_unowned_cats, fn ->
        [page: unowned_page, page_size: unowned_page_size, filter: unowned_filter]
        |> Client.new()
        |> Client.list_looking_for_adoption_cats(false)
      end)

    {:noreply, socket}
  end

  @impl true
  def handle_info({:filter_owned_cat, %Cat.Filter{} = filter}, socket) do
    unowned_params = Cat.Filter.to_params(socket.assigns.unowned_filter, "unowned_cat")
    owned_params = Cat.Filter.to_params(filter, "owned_cat")

    socket =
      push_patch(socket,
        to:
          ~p"/adopcja/szukaja-domu" <>
            "?#{owned_params}" <>
            unowned_params,
        replace: true
      )

    {:noreply, socket}
  end

  @impl true
  def handle_info({:filter_unowned_cat, %Cat.Filter{} = filter}, socket) do
    owned_filter = Cat.Filter.to_params(socket.assigns.owned_filter, "owned_cat")
    unowned_filter = Cat.Filter.to_params(filter, "unowned_cat")

    socket =
      push_patch(socket,
        to:
          ~p"/adopcja/szukaja-domu" <>
            "?#{owned_filter}" <>
            unowned_filter,
        replace: true
      )

    {:noreply, socket}
  end

  defp items_per_page, do: [30, 60, 90]

  defp cats_amount_string(amount) do
    cond do
      amount == 1 -> "#{amount} kot"
      amount in [2, 3, 4] -> "#{amount} koty"
      amount > 4 -> "#{amount} kotów"
      true -> "0 kotów"
    end
  end

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
