defmodule KotkowoWeb.AdoptionLive.Cat do
  @moduledoc false
  use KotkowoWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket

    {:ok, socket}
  end

  @impl true
  def handle_params(unsigned_params, uri, socket) do
    %URI{
      path: path
    } = URI.parse(uri)

    route_info =
      Phoenix.Router.route_info(KotkowoWeb.Router, "GET", path, "myhost")
      |> dbg()

    URLHelper.interpolate_params(path, unsigned_params)
    |> dbg()

    {:noreply, socket}
  end
end
