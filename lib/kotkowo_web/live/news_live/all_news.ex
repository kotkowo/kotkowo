defmodule KotkowoWeb.NewsLive.AllNews do
  @moduledoc false
  use KotkowoWeb, :live_view

  import KotkowoWeb.Components.Static.HowYouCanHelpSection

  alias Kotkowo.StrapiClient

  @first_page 1
  @default_limit 30

  @impl true
  def mount(params, _session, socket) do
    limit = params |> Map.get("limit", Integer.to_string(@default_limit)) |> String.to_integer()

    {:ok, max_page} = StrapiClient.get_announcement_list_pages(limit)

    socket =
      assign(socket, :max_page, max_page)

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    limit = params |> Map.get("limit", Integer.to_string(@default_limit)) |> String.to_integer()
    page = params |> Map.get("page", Integer.to_string(@first_page)) |> String.to_integer()

    page =
      cond do
        page < @first_page -> @first_page
        page > socket.assigns.max_page -> socket.assigns.max_page
        true -> page
      end

    offset = (page - 1) * limit
    {:ok, news} = StrapiClient.list_announcements(limit, offset)

    socket =
      socket
      |> assign(:news, news)
      |> assign(:page, page)
      |> assign(:limit, limit)

    {:noreply, socket}
  end

  @impl true
  def handle_event("items_amount", %{"items_per_page" => amount}, socket) do
    limit = String.to_integer(amount)
    params = %{limit: limit, page: socket.assigns.page}
    {:ok, max_page} = StrapiClient.get_announcement_list_pages(limit)

    socket =
      socket
      |> assign(:max_page, max_page)
      |> push_patch(to: ~p"/aktualnosci/z-ostatniej-chwili/wszystkie?#{params}")

    {:noreply, socket}
  end

  @impl true
  def handle_event("select_page", %{"value" => page}, socket) do
    params = %{page: page, limit: socket.assigns.limit}
    socket = push_patch(socket, to: ~p"/aktualnosci/z-ostatniej-chwili/wszystkie?#{params}")
    {:noreply, socket}
  end

  defp items_per_page, do: [30, 60, 90]

  attr :selected_page, :integer, required: true
  attr :last_page, :integer, required: true

  def pagination_bar(assigns) do
    assigns =
      assigns
      |> assign(:previous_page, assigns.selected_page - 1)
      |> assign(:next_page, assigns.selected_page + 1)
      |> assign(:first_page, @first_page)

    ~H"""
    <div class="flex flex-row text-xl gap-x-4 text-lg">
      <button :if={@selected_page != @first_page} phx-click="select_page" class="p-4" value={@selected_page - 1}>
        <.icon class=" rotate-90 brightness-0" name="chevron_down" />
      </button>
      
        <.icon  :if={@selected_page == @first_page} class="rotate-90 p-4 grayscale" name="chevron_down" />
      <div class="self-center gap-4 hidden lg:inline">
        <button :if={@selected_page > 2} class="w-14 h-14" phx-click="select_page" value={@first_page}>
          <%=@first_page%>
        </button>
        <span :if={@selected_page > 2} class="w-14 h-14">...</span>
        <button
          :if={@selected_page != @first_page}
          class="w-14 h-14"
          phx-click="select_page"
          value={@previous_page}
        >
          <%= @previous_page %>
        </button>
        <button class="font-bold w-14 h-14">
          <%= @selected_page %>
        </button>
        <button
          :if={@selected_page != @last_page}
          class="w-14 h-14"
          phx-click="select_page"
          value={@next_page}
        >
          <%= @next_page %>
        </button>
        <span :if={@selected_page < @last_page - 1} class="w-14 h-14">...</span>

        <button
          :if={@selected_page < @last_page - 1}
          class="w-14 h-14"
          phx-click="select_page"
          value={@last_page}
        >
          <%= @last_page %>
        </button>
      </div>
      <div class="self-center flex flex-row lg:hidden gap-4">
        <span><%= @selected_page %></span>
        <span>z</span>
        <span><%= @last_page %></span>
      </div>
              <.icon :if={@selected_page == @last_page}  class="rotate-90 p-4 grayscale" name="chevron_up" />


      <button
        :if={@selected_page != @last_page}
        class="p-4"
        phx-click="select_page"
        value={@selected_page + 1}
      >
              <.icon class="rotate-90 brightness-0" name="chevron_up" />

      </button>
    </div>
    """
  end
end
