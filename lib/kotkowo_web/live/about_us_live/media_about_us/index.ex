defmodule KotkowoWeb.AboutUsLive.MediaAboutUsLive.Index do
  @moduledoc false
  use KotkowoWeb, :live_view

  import KotkowoWeb.Components.Static.HowYouCanHelpSection
  import KotkowoWeb.Constants

  alias Kotkowo.Client
  alias Kotkowo.Client.Paged

  require Logger

  def handle_async(:load_media, {:ok, media}, socket) do
    socket =
      case media do
        {:ok, %Paged{items: external_media}} ->
          assign(socket, :external_media, external_media)

        {:error, msg} ->
          Logger.error(msg)
          socket
      end

    {:noreply, socket}
  end

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:external_media, nil)
      |> start_async(:load_media, fn -> [page_size: 8] |> Client.new() |> Client.list_external_media() end)

    {:ok, socket}
  end
end
