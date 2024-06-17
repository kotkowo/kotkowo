defmodule KotkowoWeb.NewsLive.Index do
  @moduledoc false
  use KotkowoWeb, :live_view

  import KotkowoWeb.Components.Static.HowYouCanHelpSection

  alias Kotkowo.Client
  alias Kotkowo.Client.Cat.Filter
  alias Kotkowo.Client.Image
  alias Kotkowo.Client.Paged

  require Logger

  @impl true
  def mount(_params, _session, socket) do
    filter = nil |> Filter.from_params() |> Map.put(:include_adopted, true)
    dead_filter = Map.put(filter, :is_dead, true)
    alive_filter = Map.put(filter, :is_dead, false)

    socket =
      socket
      |> assign(:news, nil)
      |> assign(:found_home, nil)
      |> assign(:passed_away, nil)
      |> start_async(:load_announcements, fn ->
        [page: 0, page_size: 3] |> Client.new() |> Client.list_announcements()
      end)
      |> start_async(:load_adopted_cats, fn ->
        [page: 0, page_size: 3, filter: alive_filter] |> Client.new() |> Client.list_adopted_cats()
      end)
      |> start_async(:load_passed_away, fn ->
        [page: 0, page_size: 3, filter: dead_filter] |> Client.new() |> Client.list_cats()
      end)

    {:ok, socket}
  end

  @impl true
  def handle_async(:load_passed_away, {:ok, passed_away}, socket) do
    socket =
      case passed_away do
        {:ok, %Paged{items: cats}} -> assign(socket, :passed_away, cats)
        {:error, msg} -> Logger.error(msg)
      end

    {:noreply, socket}
  end

  @impl true
  def handle_async(:load_adopted_cats, {:ok, adopted_cats}, socket) do
    socket =
      case adopted_cats do
        {:ok, %Paged{items: cats}} -> assign(socket, :found_home, cats)
        {:error, msg} -> Logger.error(msg)
      end

    {:noreply, socket}
  end

  @impl true
  def handle_async(:load_announcements, {:ok, announcements}, socket) do
    socket =
      case announcements do
        {:ok, %Paged{items: news}} -> assign(socket, :news, news)
        {:error, msg} -> Logger.error(msg)
      end

    {:noreply, socket}
  end
end
