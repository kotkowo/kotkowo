defmodule KotkowoWeb.AdviceLive.Index do
  @moduledoc false
  use KotkowoWeb, :live_view

  import KotkowoWeb.Components.Static.HowYouCanHelpSection

  alias Kotkowo.Client
  alias Kotkowo.Client.Advice
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
  def handle_async(:load_popular_titles, {:ok, titles}, socket) do
    socket =
      case titles do
        {:ok, %Paged{items: popular_titles}} ->
          assign(socket, :popular_titles, popular_titles)

        {:error, message} ->
          Logger.error(message)
          put_flash(socket, :error, "Błąd podczas wczytywania najczęściej czytanych artykułów")
      end

    {:noreply, socket}
  end

  @impl true
  def handle_async(:load_advices, {:ok, advices}, socket) do
    socket =
      case advices do
        {:ok, %Paged{items: advice}} ->
          {header_advice, advice} = List.pop_at(advice, 0)
          {popular_advice, advice} = Enum.split(advice, 2)

          advice =
            Enum.take(advice, 4)

          socket
          |> assign(:advice, advice)
          |> assign(:header_advice, header_advice)
          |> assign(:popular_advice, popular_advice)
          |> assign_async(:article, fn -> {:ok, %{article: get_article(header_advice)}} end)

        {:error, message} ->
          Logger.error(message)

          socket
          |> assign(:advice, [])
          |> assign(:header_advice, nil)
          |> assign(:popular_advice, [])
          |> assign(:popular_titles, [])
          |> put_flash(:error, "Błąd podczas wczytywania porad.")
      end

    {:noreply, socket}
  end

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:header_advice, :loading)
      |> assign(:popular_advice, nil)
      |> assign(:popular_titles, nil)
      |> assign(:advice, nil)
      |> assign(:article, nil)
      |> start_async(:load_advices, fn ->
        [page: 0, page_size: 7] |> Client.new() |> Client.list_advices()
      end)
      |> start_async(:load_popular_titles, fn ->
        [page: 0, page_size: 3, sort: "updatedAt:desc", sort: "views:desc"]
        |> Client.new()
        |> Client.list_advices()
      end)

    {:ok, socket}
  end

  defp get_article(nil), do: :error

  defp get_article(%Advice{} = advice) do
    case Client.get_advice_article(advice.id) do
      {:ok, %Article{} = article} ->
        article

      {:error, message} ->
        Logger.error(message)
        :error
    end
  end
end
