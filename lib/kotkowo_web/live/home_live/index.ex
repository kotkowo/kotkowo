defmodule KotkowoWeb.HomeLive.Index do
  @moduledoc false

  use KotkowoWeb, :live_view

  import KotkowoWeb.Components.Steps

  alias Kotkowo.StrapiClient

  require Logger

  @impl true
  def mount(_params, _session, socket) do
    news =
      case StrapiClient.list_announcements(3) do
        {:ok, news} ->
          news

        {:error, {_reason, message}} ->
          Logger.error(message)
          :error
      end

    socket = assign(socket, :news, news)

    {:ok, socket}
  end
end
