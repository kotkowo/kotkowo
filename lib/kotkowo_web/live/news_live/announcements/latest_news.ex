defmodule KotkowoWeb.AnnouncementsLive.LatestNews do
  @moduledoc false
  use KotkowoWeb, :live_view

  import KotkowoWeb.Components.Static.HowYouCanHelpSection

  alias Kotkowo.Article
  alias Kotkowo.Client
  alias Kotkowo.Client.Announcement
  alias Kotkowo.Client.Paged
  alias Kotkowo.StrapiClient

  @impl true
  def mount(_params, _session, socket) do
    {:ok, %Paged{items: news, page_count: _page_count, page_size: _page_size, page: _page, total: _total}} =
      [page: 0, page_size: 7, filter: nil] |> Client.new() |> Client.list_announcements()

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

  defp get_article(nil), do: nil

  defp get_article(%Announcement{} = news) do
    case StrapiClient.get_article_for_announcement(news.id) do
      {:ok, %Article{} = article} -> article
      _ -> nil
    end
  end
end
