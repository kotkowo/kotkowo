defmodule KotkowoWeb.NewsLive.LatestNews do
  @moduledoc false
  use KotkowoWeb, :live_view

  import KotkowoWeb.Components.Static.HowYouCanHelpSection

  alias Kotkowo.Announcement
  alias Kotkowo.Article
  alias Kotkowo.GalleryImage
  alias Kotkowo.StrapiClient

  @impl true
  def mount(_params, _session, socket) do
    {:ok, news} = StrapiClient.list_announcements(7)

    {header_news, news} = List.pop_at(news, 0)
    {popular_news, news} = Enum.split(news, 2)

    news =
      Enum.take(news, 4)

    article = get_article(header_news)

    socket =
      socket
      |> assign(:article, article)
      |> assign(:news, news)
      |> assign(:header_news, header_news)
      |> assign(:popular_news, popular_news)
      |> assign(:popular_titles, [header_news | popular_news])

    {:ok, socket}
  end

  defp get_article(%Announcement{} = news) do
    case StrapiClient.get_article_for_announcement(Integer.to_string(news.id)) do
      {:ok, %Article{} = article} -> article
      _ -> nil
    end
  end
end
