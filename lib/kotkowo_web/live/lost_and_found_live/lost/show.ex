defmodule KotkowoWeb.LostAndFoundLive.LostLive.Show do
  @moduledoc false
  use KotkowoWeb, :live_view

  import KotkowoWeb.Components.CatViewUtils
  import KotkowoWeb.Constants

  alias Kotkowo.Client
  alias Kotkowo.Client.Cat
  alias Kotkowo.Client.LostCat
  alias KotkowoWeb.Components.CatGallery

  require Logger

  def handle_async(:load_cat, {:ok, cat}, socket) do
    case cat do
      {:ok, %LostCat{} = cat} ->
        images = cat.cat.images
        {:noreply, socket |> assign(:cat, cat) |> assign(:images, images)}

      {:error, message} ->
        Logger.error(message)

        {:noreply,
         socket
         |> put_flash(:error, "Nie znaleziono kota")
         |> push_navigate(to: ~p"/zaginione-znalezione/zaginione", replace: true)}
    end
  end

  def mount(%{"slug" => slug}, _session, socket) do
    socket =
      socket
      |> assign(:cat, nil)
      |> assign(:slug, slug)
      |> assign(:images, [])
      |> assign(:current_image, 0)
      |> start_async(:load_cat, fn -> Client.get_lost_cat_by_slug(slug) end)

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
