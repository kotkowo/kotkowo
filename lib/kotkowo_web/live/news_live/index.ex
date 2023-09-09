defmodule KotkowoWeb.NewsLive.Index do
  @moduledoc false

  use KotkowoWeb, :live_view

  alias Kotkowo.StrapiClient

  @impl true
  def mount(_params, _session, socket) do
    {:ok, news} = StrapiClient.list_announcements(3)
    socket = assign(socket, :news, news)

    {:ok, socket}
  end
end
