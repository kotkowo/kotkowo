defmodule KotkowoWeb.NewsLive.LatestNews do
  @moduledoc false
  use KotkowoWeb, :live_view

  import KotkowoWeb.Components.Static.HowYouCanHelpSection

  alias Kotkowo.GalleryImage
  alias Kotkowo.StrapiClient

  @impl true
  def mount(_params, _session, socket) do
    {:ok, [header_news | tail]} = StrapiClient.list_announcements(7)
    popular_news = Enum.take(tail, 2)

    news =
      tail
      |> Enum.drop(2)
      |> Enum.take(4)

    {:ok, article} =
      header_news
      |> Map.get(:id)
      |> Integer.to_string()
      |> StrapiClient.get_article_for_announcement()

    socket =
      socket
      |> assign(:news, news)
      |> assign(:header_news, header_news)
      |> assign(:article, article)
      |> assign(:popular_news, popular_news)
      |> assign(:popular_titles, [header_news | popular_news])

    {:ok, socket}
  end
end
