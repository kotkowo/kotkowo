defmodule KotkowoWeb.AnnouncementsLive.LatestNews do
  @moduledoc false
  use KotkowoWeb, :live_view

  import KotkowoWeb.Components.Static.HowYouCanHelpSection

  alias Kotkowo.Client
  alias Kotkowo.Client.Announcement
  alias Kotkowo.Client.Article
  alias Kotkowo.Client.Paged

  require Logger

  @impl true
  def handle_async(:load_article, {:ok, article}, socket) do
    socket =
      case article do
        :error -> assign(socket, :article, :error)
        article -> assign(socket, :article, article)
      end

    {:noreply, socket}
  end

  @impl true
  def handle_async(:load_announcements, {:ok, announcements}, socket) do
    socket =
      case announcements do
        {:ok, %Paged{items: news}} ->
          {header_news, news} = List.pop_at(news, 0)
          {popular_news, news} = Enum.split(news, 2)

          news =
            Enum.take(news, 4)

          socket
          |> assign(:news, news)
          |> assign(:header_news, header_news)
          |> assign(:popular_news, popular_news)
          |> assign(:popular_titles, [header_news | popular_news])
          |> assign_async(:article, fn -> {:ok, %{article: get_article(header_news)}} end)

        {:error, message} ->
          Logger.error(message)
          socket
      end

    {:noreply, socket}
  end

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:header_news, nil)
      |> assign(:popular_news, nil)
      |> assign(:popular_titles, nil)
      |> assign(:news, nil)
      |> assign(:article, nil)
      |> start_async(:load_announcements, fn ->
        [page: 0, page_size: 7] |> Client.new() |> Client.list_announcements()
      end)

    {:ok, socket}
  end

  defp get_article(nil), do: :error

  defp get_article(%Announcement{} = news) do
    case Client.get_article(news.id) do
      {:ok, %Article{} = article} ->
        article

      {:error, message} ->
        Logger.error(message)
        :error
    end
  end
end
