defmodule KotkowoWeb.NewsLive.NewsArticle do
  @moduledoc false
  use KotkowoWeb, :live_view

  alias Kotkowo.Article
  alias Kotkowo.GalleryImage
  alias Kotkowo.StrapiClient

  @impl true
  def mount(%{"article_id" => article_id}, _session, socket) do
    with {:ok, %Article{} = article} <- StrapiClient.get_article(article_id) do
      {:ok, popular_news} = StrapiClient.list_announcements(3)

      socket =
        socket
        |> assign(:article, article)
        |> assign(:popular_news, popular_news)

      {:ok, socket}
    end
  end
end
