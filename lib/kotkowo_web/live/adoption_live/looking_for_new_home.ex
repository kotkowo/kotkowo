defmodule KotkowoWeb.AdoptionLive.LookingForNewHome do
  @moduledoc false
  use KotkowoWeb, :live_view

  alias Kotkowo.StrapiClient

  @impl true
  def mount(_params, _session, socket) do
    {:ok, cats} = StrapiClient.list_cats()

    socket =
      socket
      |> assign(:cats, cats)
      |> assign(:filtered_cats, cats)

    {:ok, socket}
  end

  @impl true
  def handle_event("cat_search", %{"cat_search" => search}, socket) do
    cats = socket.assigns.cats

    filtered_cats =
      if String.trim(search) == "" do
        cats
      else
        Enum.filter(cats, fn cat ->
          name = String.downcase(cat.name)
          search = String.downcase(search)
          String.contains?(name, search)
        end)
      end

    socket = assign(socket, :filtered_cats, filtered_cats)

    {:noreply, socket}
  end
end
