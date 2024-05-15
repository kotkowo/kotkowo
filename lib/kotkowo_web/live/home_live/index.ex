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
  def mount(_params, _session, socket) do
    client = Client.new(page: 1, page_size: 3, filter: nil)

    news =
      case Client.list_announcements(client) do
        {:ok, %Paged{items: news, page_count: _page_count, page_size: _page_size, page: _page, total: _total}} ->
          news

        {:error, message} ->
          Logger.error(message)
          :error
      end

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
      |> assign(:news, news)
      |> assign(:in_need_of_a_new_home, in_need_of_a_new_home)

    {:ok, socket}
  end
end
