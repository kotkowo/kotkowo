defmodule KotkowoWeb.AnnouncementsLive.NewsArticle do
  @moduledoc false
  use KotkowoWeb, :live_view

  import KotkowoWeb.Components.Static.HowYouCanHelpSection

  alias Kotkowo.Article
  alias Kotkowo.Client
  alias Kotkowo.Client.Paged
  alias Kotkowo.GalleryImage
  alias Kotkowo.StrapiClient

  @impl true
  def mount(%{"article_id" => article_id}, _session, socket) do
    with {:ok, %Article{} = article} <- StrapiClient.get_article_for_announcement(article_id) do
      {:ok, %Paged{items: popular_news, page_count: _page_count, page_size: _page_size, page: _page, total: _total}} =
        [page: 0, page_size: 3, filter: nil] |> Client.new() |> Client.list_announcements()

      socket =
        socket
        |> assign(:article_id, article_id)
        |> assign(:article, article)
        |> assign(:popular_news, popular_news)

      {:ok, socket}
    end
  end
end
