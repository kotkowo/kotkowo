defmodule KotkowoWeb.AnnouncementsLive.NewsArticle do
  @moduledoc false
  use KotkowoWeb, :live_view

  import KotkowoWeb.Components.Static.HowYouCanHelpSection

  alias Kotkowo.Client
  alias Kotkowo.Client.Article
  alias Kotkowo.Client.Paged

  require Logger

  @impl true
  def handle_event("set_content", %{"content" => content}, socket) do
    {:noreply, assign(socket, :content, content)}
  end

  @impl true
  def handle_async(:load_popular_announcements, {:ok, announcements}, socket) do
    case announcements do
      {:ok, %Paged{items: popular_news}} ->
        {:noreply, assign(socket, :popular_news, popular_news)}

      {:error, message} ->
        Logger.error(message)
        {:noreply, assign(socket, :popular_news, :error)}
    end
  end

  @impl true
  def handle_async(:load_article, {:ok, article}, socket) do
    case article do
      {:ok, %Article{} = article} ->
        {:noreply, assign(socket, :article, article)}

      {:error, message} ->
        Logger.error(message)

        {:noreply,
         socket
         |> assign(:article, nil)
         |> put_flash(:error, "Nie znaleziono artykułu")
         |> push_navigate(to: ~p"/aktualnosci/z-ostatniej-chwili", replace: true)}
    end
  end

  @impl true
  def mount(%{"announcement_id" => announcement_id}, _session, socket) do
    socket =
      socket
      |> assign(:popular_news, nil)
      |> assign(:article_id, announcement_id)
      |> assign(:article, nil)
      |> assign(:content, "")
      |> start_async(:load_article, fn ->
        Client.get_article(announcement_id)
      end)
      |> start_async(:load_popular_announcements, fn ->
        [page: 0, page_size: 3, sort: "updatedAt:desc", sort: "views:desc"] |> Client.new() |> Client.list_announcements()
      end)

    {:ok, socket}
  end
end
