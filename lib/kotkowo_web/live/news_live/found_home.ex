defmodule KotkowoWeb.NewsLive.FoundHome do
  @moduledoc false
  use KotkowoWeb, :live_view

  import KotkowoWeb.Components.Pagination
  import KotkowoWeb.Components.Static.HowYouCanHelpSection
  import KotkowoWeb.Constants

  alias Kotkowo.Client
  alias Kotkowo.Client.Cat
  alias Kotkowo.Client.Image
  alias Kotkowo.Client.Paged

  require Logger

  defp parse_int_param(nil), do: nil
  defp parse_int_param(page) when is_integer(page), do: page

  defp parse_int_param(page) when is_binary(page) do
    case Integer.parse(page) do
      {page, _rest} -> page
      _ -> nil
    end
  end

  @impl true
  def handle_event("items_amount", %{"items_per_page" => amount}, socket) do
    page_size = String.to_integer(amount)
    params = %{socket.assigns.params | page_size: page_size}

    socket =
      push_patch(socket,
        to: ~p"/aktualnosci/znalazly-dom?#{params}" <> "#{Cat.Filter.to_params(socket.assigns.filter)}",
        replace: true
      )

    {:noreply, socket}
  end

  @impl true
  def handle_event("select_page", %{"value" => page}, socket) do
    params = %{socket.assigns.params | page: page}

    socket =
      push_patch(socket,
        to: ~p"/aktualnosci/znalazly-dom?#{params}" <> "#{Cat.Filter.to_params(socket.assigns.filter)}",
        replace: true
      )

    {:noreply, socket}
  end

  @impl true
  def handle_async(:load_cats, {:ok, cats}, socket) do
    socket =
      case cats do
        {:ok, %Paged{items: cats, page_count: page_count, page_size: page_size, page: page, total: total}} ->
          params = %{page: page, page_size: page_size}
          page_count = max(1, page_count)

          if page <= page_count do
            socket
            |> stream(:cats, cats, reset: true)
            |> assign(:cats_total, total)
            |> assign(:page_count, page_count)
            |> assign(:params, params)
          else
            push_patch(socket, to: ~p"/aktualnosci/znalazly-dom" <> "?#{Cat.Filter.to_params(socket.assigns.filter)}")
          end

        {:error, msg} ->
          Logger.error(msg)
          socket
      end

    {:noreply, socket}
  end

  @impl true
  def mount(_params, _session, socket) do
    socket = socket |> stream(:cats, []) |> assign(:params, nil)
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    filter = Cat.Filter.from_params(params["cat"])

    adopted_filter = Map.put(filter, :is_dead, false)
    page_size = params |> Map.get("page_size", "30") |> parse_int_param()
    page = params |> Map.get("page") |> parse_int_param()

    socket =
      socket
      |> assign(:filter, filter)
      |> start_async(:load_cats, fn ->
        [page: page, page_size: page_size, filter: adopted_filter] |> Client.new() |> Client.list_adopted_cats()
      end)

    {:noreply, socket}
  end

  @impl true
  def handle_info({:filter_cat, %Cat.Filter{} = filter}, socket) do
    {:noreply,
     push_patch(socket,
       to: ~p"/aktualnosci/znalazly-dom?#{socket.assigns.params}" <> "#{Cat.Filter.to_params(filter)}",
       replace: true
     )}
  end

  defp items_per_page, do: [30, 60, 90]
end
