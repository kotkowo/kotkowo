defmodule KotkowoWeb.NewsLive.LatestNews do
  @moduledoc false
  use KotkowoWeb, :live_view

  alias Kotkowo.StrapiClient

  @impl true
  def mount(_params, _session, socket) do
    {:ok, header_news} = StrapiClient.list_announcements(1)
    {:ok, popular_news} = StrapiClient.list_announcements(2, 1)
    {:ok, news} = StrapiClient.list_announcements(4, 3)

    socket =
      socket
      |> assign(:news, news)
      |> assign(:header_news, header_news)
      |> assign(:popular_news, popular_news)
      |> assign(:popular_titles, header_news ++ popular_news)

    {:ok, socket}
  end
end
