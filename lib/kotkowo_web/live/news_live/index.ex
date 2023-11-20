defmodule KotkowoWeb.NewsLive.Index do
  @moduledoc false
  use KotkowoWeb, :live_view

  import KotkowoWeb.Components.Static.HowYouCanHelpSection

  alias Kotkowo.GalleryImage
  alias Kotkowo.StrapiClient

  @impl true
  def mount(_params, _session, socket) do
    {:ok, news} = StrapiClient.list_announcements(3)
    {:ok, found_home} = StrapiClient.list_adopted_cats(3)
    {:ok, passed_away} = StrapiClient.list_cats(true, 3)

    socket =
      socket
      |> assign(:news, news)
      |> assign(:found_home, found_home)
      |> assign(:passed_away, passed_away)

    {:ok, socket}
  end
end
