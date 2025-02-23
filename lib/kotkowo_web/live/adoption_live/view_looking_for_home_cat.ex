defmodule KotkowoWeb.AdoptionLive.ViewLookingForHomeCat do
  @moduledoc false
  use KotkowoWeb, :live_view

  import KotkowoWeb.Components.CatViewUtils
  import KotkowoWeb.Constants

  alias Kotkowo.Client
  alias Kotkowo.Client.LookingForHomeCat
  alias KotkowoWeb.Components.CatGallery

  require Logger

  def handle_async(:load_cat, {:ok, cat}, socket) do
    case cat do
      {:ok, %LookingForHomeCat{} = cat} ->
        images = cat.cat.images
        caretaker = cat.caretaker
        cat = cat.cat
        socket = socket |> assign(:cat, cat) |> assign(:images, images) |> assign(:caretaker, caretaker)
        {:noreply, socket}

      {:error, message} ->
        Logger.error(message)

        {:noreply,
         socket
         |> put_flash(:error, "Nie znaleziono kota")
         |> push_navigate(to: ~p"/adopcja/szukaja-domu", replace: true)}
    end
  end

  def mount(%{"slug" => slug}, _session, socket) do
    socket =
      socket
      |> assign(:cat, nil)
      |> assign(:slug, slug)
      |> assign(:images, [])
      |> assign(:current_image, 0)
      |> start_async(:load_cat, fn -> Client.get_lfh_cat_by_slug(slug) end)

    {:ok, socket}
  end

  def handle_params(params, url, socket) do
    current_image =
      case params |> Map.get("image", "0") |> Integer.parse() do
        {n, _} -> n
        _ -> 0
      end

    socket =
      socket
      |> assign(:path, url)
      |> assign(:current_image, current_image)

    {:noreply, socket}
  end
end
