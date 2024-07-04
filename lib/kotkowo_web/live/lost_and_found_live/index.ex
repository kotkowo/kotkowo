defmodule KotkowoWeb.LostAndFoundLive.Index do
  @moduledoc false
  use KotkowoWeb, :live_view

  import KotkowoWeb.Components.Static.HowYouCanHelpSection
  import KotkowoWeb.Components.Steps
  import KotkowoWeb.Constants
  import KotkowoWeb.WebHelpers

  alias Kotkowo.Client
  alias Kotkowo.Client.Cat
  alias Kotkowo.Client.Image
  alias Kotkowo.Client.Paged

  require Logger

  @impl true
  def handle_async(:load_found_cats, {:ok, cats}, socket) do
    socket =
      case cats do
        {:ok, %Paged{items: cats}} ->
          assign(socket, :found_cats, cats)

        {:error, msg} ->
          Logger.error(msg)
          socket
      end

    {:noreply, socket}
  end

  @impl true
  def handle_async(:load_lost_cats, {:ok, cats}, socket) do
    socket =
      case cats do
        {:ok, %Paged{items: cats}} ->
          assign(socket, :lost_cats, cats)

        {:error, msg} ->
          Logger.error(msg)
          socket
      end

    {:noreply, socket}
  end

  @impl true
  def handle_event("query_lost", %{"chip_number" => chip_number}, socket) do
    chip_number = unless chip_number == "", do: chip_number
    raw_lost_filter = Map.put(socket.assigns.raw_lost_filter, :chip_number, chip_number)
    filter = Cat.Filter.from_map(raw_lost_filter)

    params =
      Cat.Filter.to_params(filter, "lost_cat")

    socket =
      socket
      |> assign(:raw_lost_filter, raw_lost_filter)
      |> start_async(:load_lost_cats, fn -> [filter: filter] |> Client.new() |> Client.list_lost_cats() end)
      |> push_patch(
        to:
          ~p"/zaginione-znalezione" <>
            "?#{params}" <>
            "#{socket.assigns.raw_found_filter |> Cat.Filter.from_map() |> Cat.Filter.to_params("found_cat")}"
      )

    {:noreply, socket}
  end

  @impl true
  def handle_event("query_seen_found", %{"chip_number" => chip_number}, socket) do
    chip_number = unless chip_number == "", do: chip_number
    raw_found_filter = Map.put(socket.assigns.raw_found_filter, :chip_number, chip_number)

    filter =
      Cat.Filter.from_map(raw_found_filter)

    params = Cat.Filter.to_params(filter, "found_cat")

    socket =
      socket
      |> assign(:raw_found_filter, raw_found_filter)
      |> start_async(:load_found_cats, fn -> [filter: filter] |> Client.new() |> Client.list_found_cats() end)
      |> push_patch(
        to:
          ~p"/zaginione-znalezione" <>
            "?#{params}" <>
            "#{socket.assigns.raw_lost_filter |> Cat.Filter.from_map() |> Cat.Filter.to_params("lost_cat")}"
      )

    {:noreply, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    lost_filter = Cat.Filter.from_params(params["lost_cat"])
    found_filter = Cat.Filter.from_params(params["found_cat"])

    socket =
      socket
      |> start_async(:load_found_cats, fn -> [filter: found_filter] |> Client.new() |> Client.list_found_cats() end)
      |> start_async(:load_lost_cats, fn -> [filter: lost_filter] |> Client.new() |> Client.list_lost_cats() end)

    {:noreply, socket}
  end

  @impl true
  def mount(params, _session, socket) do
    lost_filter = Cat.Filter.from_params(params["lost_cat"])
    found_filter = Cat.Filter.from_params(params["found_cat"])
    raw_lost_filter = sanitize_filter_to_map(lost_filter)
    raw_found_filter = sanitize_filter_to_map(found_filter)

    socket =
      socket
      |> assign(:raw_found_filter, raw_found_filter)
      |> assign(:raw_lost_filter, raw_lost_filter)
      |> assign(:found_cats, nil)
      |> assign(:lost_cats, nil)

    {:ok, socket}
  end

  defp sanitize_filter_to_map(filter) do
    filter
    |> Map.from_struct()
    |> Map.new(fn
      {k, {_, v}} -> {k, v}
      {k, v} -> {k, v}
    end)
  end
end
