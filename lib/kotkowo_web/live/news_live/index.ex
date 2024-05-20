defmodule KotkowoWeb.NewsLive.Index do
  @moduledoc false
  use KotkowoWeb, :live_view

  import KotkowoWeb.Components.Static.HowYouCanHelpSection

  alias Kotkowo.Client
  alias Kotkowo.Client.Paged
  alias Kotkowo.GalleryImage
  alias Kotkowo.StrapiClient
  alias Phoenix.LiveView.AsyncResult

  require Logger

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:news, nil)
      |> assign(:found_home, %AsyncResult{})
      |> assign(:passed_away, %AsyncResult{})
      |> start_async(:load_announcements, fn ->
        [page: 0, page_size: 3] |> Client.new() |> Client.list_announcements()
      end)
      |> assign_async(:found_home, fn -> {:ok, %{found_home: get_found_home()}} end)
      |> assign_async(:passed_away, fn -> {:ok, %{passed_away: get_passed_away()}} end)

    {:ok, socket}
  end

  def get_passed_away do
    case StrapiClient.list_cats(true, nil, 3) do
      {:ok, cats} -> cats
      _ -> nil
    end
  end

  def get_found_home do
    case StrapiClient.list_adopted_cats(3) do
      {:ok, cats} -> cats
      _ -> nil
    end
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
