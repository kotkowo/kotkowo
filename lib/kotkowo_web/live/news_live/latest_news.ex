defmodule KotkowoWeb.NewsLive.LatestNews do
  @moduledoc false
  use KotkowoWeb, :live_view

  alias Kotkowo.GalleryImage
  alias Kotkowo.StrapiClient

  @impl true
  def mount(_params, _session, socket) do
    {:ok, header_news} = StrapiClient.list_announcements(1)
    {:ok, popular_news} = StrapiClient.list_announcements(2, 1)
    {:ok, news} = StrapiClient.list_announcements(4, 3)
    {:ok, article} = StrapiClient.get_article(Integer.to_string(hd(header_news).id))

    socket =
      socket
      |> assign(:news, news)
      |> assign(:header_news, header_news)
      |> assign(:article, article)
      |> assign(:popular_news, popular_news)
      |> assign(:popular_titles, header_news ++ popular_news)

    {:ok, socket}
  end
end
