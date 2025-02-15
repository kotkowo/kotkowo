defmodule KotkowoWeb.AdoptionLive.LookingForNewHome do
  @moduledoc false
  use KotkowoWeb, :live_view

  import KotkowoWeb.Components.Pagination
  import KotkowoWeb.Components.Static.HowYouCanHelpSection
  import KotkowoWeb.Constants

  alias Kotkowo.Client
  alias Kotkowo.Client.Cat
  alias Kotkowo.Client.Image
  alias Kotkowo.Client.Paged

  require Logger

  @first_page 1

  defp parse_int_param(nil), do: nil
  defp parse_int_param(page) when is_integer(page), do: page

  defp parse_int_param(page) when is_binary(page) do
    case Integer.parse(page) do
      {page, _rest} -> page
      _ -> nil
    end
  end

  @impl true
  def handle_event("items_amount_owned", %{"items_per_page" => amount}, socket) do
    limit = String.to_integer(amount)
    params = %{socket.assigns.params | owned_limit: limit}

    socket =
      socket
      |> assign(:params, params)
      |> push_patch(
        to:
          ~p"/adopcja/szukaja-domu?#{params}" <>
            "#{Cat.Filter.to_params(socket.assigns.owned_filter, "owned_cat")}" <>
            "#{Cat.Filter.to_params(socket.assigns.unowned_filter, "unowned_cat")}",
        replace: true
      )

    {:noreply, socket}
  end

  @impl true
  def handle_event("items_amount_unowned", %{"items_per_page" => amount}, socket) do
    limit = String.to_integer(amount)
    params = %{socket.assigns.params | unowned_limit: limit}

    socket =
      socket
      |> assign(:params, params)
      |> push_patch(
        to:
          ~p"/adopcja/szukaja-domu?#{params}" <>
            "#{Cat.Filter.to_params(socket.assigns.owned_filter, "owned_cat")}" <>
            "#{Cat.Filter.to_params(socket.assigns.unowned_filter, "unowned_cat")}",
        replace: true
      )

    {:noreply, socket}
  end

  @impl true
  def handle_event("select_owned_page", %{"value" => page}, socket) do
    params = %{socket.assigns.params | owned_page: page}

    socket =
      push_patch(socket,
        to:
          ~p"/adopcja/szukaja-domu?#{params}" <>
            "#{Cat.Filter.to_params(socket.assigns.owned_filter, "owned_cat")}" <>
            "#{Cat.Filter.to_params(socket.assigns.unowned_filter, "unowned_cat")}",
        replace: true
      )

    {:noreply, socket}
  end

  @impl true
  def handle_event("select_unowned_page", %{"value" => page}, socket) do
    params = %{socket.assigns.params | unowned_page: page}

    socket =
      push_patch(
        socket,
        to:
          ~p"/adopcja/szukaja-domu?#{params}" <>
            "#{Cat.Filter.to_params(socket.assigns.owned_filter, "owned_cat")}" <>
            "#{Cat.Filter.to_params(socket.assigns.unowned_filter, "unowned_cat")}",
        replace: true
      )

    {:noreply, socket}
  end

  @impl true
  def handle_async(:load_unowned_cats, {:ok, cats}, socket) do
    socket =
      case cats do
        {:ok, %Paged{items: unowned_cats, page_count: page_count, page_size: limit, page: page, total: total}} ->
          params = Map.merge(socket.assigns.params, %{unowned_page: page, unowned_limit: limit})
          # NOTE: page_count = 0, page = 1 for no results when filteredcat_filt
          page_count = max(1, page_count)

          if page <= page_count do
            socket
            |> stream(:unowned_cats, unowned_cats, reset: true)
            |> assign(:unowned_cats_total, total)
            |> assign(:unowned_page_count, page_count)
            |> assign(:params, params)
          else
            push_patch(socket,
              to:
                ~p"/adopcja/szukaja-domu" <>
                  "?#{Cat.Filter.to_params(socket.assigns.owned_filter, "owned_cat")}" <>
                  "#{Cat.Filter.to_params(socket.assigns.unowned_filter, "unowned_cat")}"
            )
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
        {:ok, %Paged{items: owned_cats, page_count: page_count, page_size: limit, page: page, total: total}} ->
          params = Map.merge(socket.assigns.params, %{owned_page: page, owned_limit: limit})
          # NOTE: page_count = 0, page = 1 for no results when filtered
          page_count = max(1, page_count)

          if page <= page_count do
            socket
            |> stream(:owned_cats, owned_cats, reset: true)
            |> assign(:owned_cats_total, total)
            |> assign(:owned_page_count, page_count)
            |> assign(:params, params)
          else
            push_patch(socket,
              to:
                ~p"/adopcja/szukaja-domu" <>
                  "?#{Cat.Filter.to_params(socket.assigns.owned_filter, "owned_cat")}" <>
                  "#{Cat.Filter.to_params(socket.assigns.unowned_filter, "unowned_cat")}"
            )
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
      |> assign(:owned_filter, initial_owned_filter)
      |> assign(:unowned_filter, initial_unowned_filter)
      |> stream(:owned_cats, [])
      |> assign(:owned_cats_total, 0)
      |> assign(:params, %{})
      |> stream(:unowned_cats, [])
      |> assign(:unowned_cats_total, 0)
      |> assign(:page, @first_page)

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    owned_filter = params["owned_cat"] |> Cat.Filter.from_params() |> Map.put(:is_dead, false)
    unowned_filter = params["unowned_cat"] |> Cat.Filter.from_params() |> Map.put(:is_dead, false)

    owned_limit = params |> Map.get("owned_limit", "30") |> parse_int_param()

    owned_page = params |> Map.get("owned_page") |> parse_int_param()

    unowned_limit = params |> Map.get("unowned_limit", "30") |> parse_int_param()

    unowned_page = params |> Map.get("unowned_page") |> parse_int_param()

    # NOTE: add section for cats not owned by kotkowo.
    socket =
      socket
      |> assign(:owned_filter, owned_filter)
      |> assign(:unowned_filter, unowned_filter)
      |> start_async(:load_owned_cats, fn ->
        [page: owned_page, page_size: owned_limit, filter: owned_filter]
        |> Client.new()
        |> Client.list_looking_for_adoption_cats(true)
      end)
      |> start_async(:load_unowned_cats, fn ->
        [page: unowned_page, page_size: unowned_limit, filter: unowned_filter]
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
          ~p"/adopcja/szukaja-domu?#{socket.assigns.params}" <>
            "#{owned_params}#{unowned_params}",
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
          ~p"/adopcja/szukaja-domu?#{socket.assigns.params}" <>
            "#{owned_filter}#{unowned_filter}",
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
end
