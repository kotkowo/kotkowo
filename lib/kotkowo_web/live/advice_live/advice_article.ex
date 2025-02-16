defmodule KotkowoWeb.AdviceLive.AdviceArticle do
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
  def handle_async(:load_popular_advices, {:ok, advices}, socket) do
    case advices do
      {:ok, %Paged{items: popular_advices}} ->
        {:noreply, assign(socket, :popular_advices, popular_advices)}

      {:error, message} ->
        Logger.error(message)
        {:noreply, assign(socket, :popular_advices, :error)}
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
  def mount(%{"advice_id" => advice_id}, _session, socket) do
    socket =
      socket
      |> assign(:popular_advices, nil)
      |> assign(:article_id, advice_id)
      |> assign(:article, nil)
      |> assign(:content, "")
      |> start_async(:load_article, fn ->
        Client.get_advice_article(advice_id)
      end)
      |> start_async(:load_popular_advices, fn ->
        [page: 0, page_size: 3] |> Client.new() |> Client.list_advices()
      end)

    {:ok, socket}
  end
end
