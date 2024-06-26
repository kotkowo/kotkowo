defmodule KotkowoWeb.HomeLive.Index do
  @moduledoc false

  use KotkowoWeb, :live_view

  import KotkowoWeb.Components.Steps
  import KotkowoWeb.Constants, only: [kotkowo_mail: 0]

  alias Kotkowo.Client
  alias Kotkowo.Client.Cat
  alias Kotkowo.Client.Image
  alias Kotkowo.Client.Paged

  require Logger

  @impl true
  def handle_async(:load_cats, {:ok, cats}, socket) do
    case cats do
      {:ok, %Paged{items: cats}} ->
        {:noreply, assign(socket, :in_need_of_a_new_home, cats)}

      {:error, message} ->
        Logger.error(message)

        socket =
          assign(socket, :in_need_of_a_new_home, :error)

        {:noreply, socket}
    end
  end

  @impl true
  def handle_async(:load_announcements, {:ok, announcements}, socket) do
    case announcements do
      {:ok, %Paged{items: news}} ->
        {:noreply, assign(socket, :news, news)}

      {:error, message} ->
        Logger.error(message)

        socket =
          socket
          |> put_flash(:error, message)
          |> assign(:news, :error)

        {:noreply, socket}
    end
  end

  @impl true
  def mount(_params, _session, socket) do
    default_opts = [page: 1, page_size: 3]

    non_dead_filter =
      Cat.Filter.from_map(%{
        is_dead: false
      })

    socket =
      socket
      |> assign(:news, [])
      |> assign(:in_need_of_a_new_home, [])
      |> start_async(:load_announcements, fn -> default_opts |> Client.new() |> Client.list_announcements() end)
      |> start_async(:load_cats, fn ->
        default_opts |> Keyword.put(:filter, non_dead_filter) |> Client.new() |> Client.list_cats()
      end)

    {:ok, socket}
  end
end
