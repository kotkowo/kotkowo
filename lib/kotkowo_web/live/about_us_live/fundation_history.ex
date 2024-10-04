defmodule KotkowoWeb.AboutUsLive.FundationHistory do
  @moduledoc false
  use KotkowoWeb, :live_view

  import KotkowoWeb.Constants

  alias Kotkowo.Client
  alias Kotkowo.Client.Cat
  alias Kotkowo.Client.Image
  alias Kotkowo.Client.Paged

  require Logger

  def handle_async(:load_found_home, {:ok, cats}, socket) do
    socket =
      case cats do
        {:ok, %Paged{items: cats}} -> assign(socket, :found_home, cats)
        {:error, msg} -> Logger.error(msg)
      end

    {:noreply, socket}
  end

  def mount(_params, _session, socket) do
    adopted_cat_filter = Map.put(%Cat.Filter{}, :is_dead, false)

    socket =
      socket
      |> assign(:found_home, nil)
      |> start_async(:load_found_home, fn ->
        [page: 0, page_size: 3, filter: adopted_cat_filter] |> Client.new() |> Client.list_adopted_cats()
      end)

    {:ok, socket}
  end

  attr :year, :string
  attr :body, :string
  attr :line, :boolean, default: true

  defp timeline_element(assigns) do
    ~H"""
    <div class="flex flex-row gap-x-16 self-center min-h-[214px] md:min-h-none md:h-[200px]">
      <div class="flex flex-row items-center gap-2">
        <div class="flex flex-col h-full shrink-0">
          <.icon class="shrink-0 min-w-6 h-6 md:h-8 md:w-8 w-6 text-primary-lighter" name="paw" />
          <div :if={@line} class="w-0.5 h-full bg-primary-lighter self-center"></div>
        </div>
        <h3 class="-mt-1 text-2xl md:text-4xl font-inter text-secondary font-bold self-start md:w-24 w-12">
          <%= @year %>
        </h3>
      </div>
      <p class="font-inter md:w-[649px] text-lg tracking-wide">
        <%= @body %>
      </p>
    </div>
    """
  end
end
