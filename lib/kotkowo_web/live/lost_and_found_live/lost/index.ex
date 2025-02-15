defmodule KotkowoWeb.LostAndFoundLive.LostLive.Index do
  @moduledoc false
  use KotkowoWeb, :live_view

  import KotkowoWeb.Components.Pagination
  import KotkowoWeb.Components.Static.HowYouCanHelpSection
  import KotkowoWeb.Constants
  import KotkowoWeb.WebHelpers

  alias Kotkowo.Client
  alias Kotkowo.Client.Cat
  alias Kotkowo.Client.Image
  alias Kotkowo.Client.Paged

  @first_page 1

  defp parse_int_param(nil), do: nil
  defp parse_int_param(page) when is_integer(page), do: page

  defp parse_int_param(page) when is_binary(page) do
    case Integer.parse(page) do
      {page, _rest} -> page
      _ -> nil
    end
  end

  @impl true
  def mount(params, _session, socket) do
    initial_filter = Cat.Filter.from_params(params["cat"])
    socket = socket |> assign(:filter, initial_filter) |> assign(:page, @first_page)
    {:ok, socket}
  end

  @impl true
  def handle_event("items_amount", %{"items_per_page" => amount}, socket) do
    limit = String.to_integer(amount)
    params = %{limit: limit, page: socket.assigns.params.page}

    socket =
      push_patch(socket,
        to: ~p"/zaginione-znalezione/zaginione?#{params}" <> "#{Cat.Filter.to_params(socket.assigns.filter)}",
        replace: true
      )

    {:noreply, socket}
  end

  @impl true
  def handle_event("select_page", %{"value" => page}, socket) do
    params = %{page: page, limit: socket.assigns.params.limit}

    socket =
      push_patch(socket,
        to: ~p"/zaginione-znalezione/zaginione?#{params}" <> "#{Cat.Filter.to_params(socket.assigns.filter)}",
        replace: true
      )

    {:noreply, socket}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    filter = Cat.Filter.from_params(params["cat"])

    limit = params |> Map.get("limit", "30") |> parse_int_param()
    page = params |> Map.get("page") |> parse_int_param()

    {:ok, %Paged{items: cats, page_count: page_count, page_size: limit, page: page, total: total}} =
      [page: page, page_size: limit, filter: filter] |> Client.new() |> Client.list_lost_cats()

    params = %{page: page, limit: limit}
    page_count = max(1, page_count)

    socket =
      if page <= page_count do
        socket
        |> stream(:cats, cats, reset: true)
        |> assign(:cats_total, total)
        |> assign(:page_count, page_count)
        |> assign(:params, params)
        |> assign(:filter, filter)
      else
        push_navigate(socket, to: ~p"/zaginione-znalezione/zaginione?#{Cat.Filter.to_params(filter)}")
      end

    {:noreply, socket}
  end

  @impl true
  def handle_info({:filter_cat, %Cat.Filter{} = filter}, socket) do
    {:noreply,
     push_patch(socket,
       to: ~p"/zaginione-znalezione/zaginione?#{socket.assigns.params}" <> "#{Cat.Filter.to_params(filter)}",
       replace: true
     )}
  end

  defp items_per_page, do: [30, 60, 90]
end
