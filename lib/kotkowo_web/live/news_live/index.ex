defmodule KotkowoWeb.NewsLive.Index do
  @moduledoc false
  use KotkowoWeb, :live_view

  alias Kotkowo.GalleryImage
  alias Kotkowo.StrapiClient

  @impl true
  def mount(params, session, socket) do
    {:ok, news} = StrapiClient.list_announcements()
    socket = assign(socket, :news, news)

    {:ok, socket}
  end

  defp news(assigns) do
    image = GalleryImage.url(assigns.img)

    ~H"""
    <.card alt="" src={image} tags={@tags} body_class="h-40 lg:h-48 rounded-t-none xl:-mt-1">
      <:title class="lg:text-xl"><%= @title %></:title>
    </.card>
    """
  end
end
