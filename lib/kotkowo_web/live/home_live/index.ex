defmodule KotkowoWeb.HomeLive.Index do
  @moduledoc false

  use KotkowoWeb, :live_view

  import KotkowoWeb.Components.Steps
  import KotkowoWeb.Constants, only: [kotkowo_mail: 0]

  alias Kotkowo.Client
  alias Kotkowo.Client.Paged
  alias Kotkowo.GalleryImage
  alias Kotkowo.StrapiClient

  require Logger

  @impl true
  def handle_info({:load_announcements}, socket) do
    client = Client.new(page: 1, page_size: 3)

    case Client.list_announcements(client) do
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
    if connected?(socket), do: send(self(), {:load_announcements})

    in_need_of_a_new_home =
      case StrapiClient.list_adopted_cats(3) do
        {:ok, result} ->
          result

        {:error, {_reason, message}} ->
          Logger.error(message)
          :error
      end

    socket =
      socket
      |> assign(:news, [])
      |> assign(:in_need_of_a_new_home, in_need_of_a_new_home)

    {:ok, socket}
  end
end
