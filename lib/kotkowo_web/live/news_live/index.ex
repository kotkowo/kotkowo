defmodule KotkowoWeb.NewsLive.Index do
  @moduledoc false
  use KotkowoWeb, :live_view

  import KotkowoWeb.Components.Static.HowYouCanHelpSection

  alias Kotkowo.Client
  alias Kotkowo.Client.Paged
  alias Kotkowo.GalleryImage
  alias Kotkowo.StrapiClient

  @impl true
  def mount(_params, _session, socket) do
    {:ok, %Paged{items: news, page_count: _page_count, page_size: _page_size, page: _page, total: _total}} =
      [page: 0, page_size: 3, filter: nil] |> Client.new() |> Client.list_announcements()

    {:ok, found_home} = StrapiClient.list_adopted_cats(3)
    {:ok, passed_away} = StrapiClient.list_cats(true, nil, 3)

    socket =
      socket
      |> assign(:news, news)
      |> assign(:found_home, found_home)
      |> assign(:passed_away, passed_away)

    {:ok, socket}
  end
end
