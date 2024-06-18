defmodule KotkowoWeb.AdoptionLive.Show do
  @moduledoc false
  use KotkowoWeb, :live_view

  import KotkowoWeb.Components.Images

  alias Kotkowo.Client
  alias Kotkowo.Client.Cat

  require Logger

  def handle_async(:load_cat, {:ok, cat}, socket) do
    case cat do
      {:ok, %Cat{} = cat} ->
        images = cat.images
        socket = socket |> assign(:cat, cat) |> assign(:images, images)
        {:noreply, socket}

      {:error, message} ->
        Logger.error(message)
        {:noreply, socket}
    end
  end

  def mount(%{"slug" => slug}, _session, socket) do
    socket =
      socket
      |> assign(:cat, nil)
      |> assign(:slug, slug)
      |> assign(:images, [])
      |> assign(:current_image, 0)
      |> start_async(:load_cat, fn -> Client.get_cat_by_slug(slug) end)

    {:ok, socket}
  end

  def handle_params(params, url, socket) do
    current_image =
      case params |> Map.get("image", "0") |> Integer.parse() do
        {n, _} ->
          last = length(socket.assigns.images) - 1

          if n in 0..last do
            n
          else
            0
          end

        _ ->
          0
      end

    socket =
      socket
      |> assign(:path, url)
      |> assign(:current_image, current_image)

    {:noreply, socket}
  end

  def handle_event("set-image", %{"value" => index}, socket) do
    {:noreply,
     push_patch(socket,
       to: ~p"/adopcja/szukaja-domu/#{socket.assigns.cat.slug}?image=#{index}",
       replace: true
     )}
  end

  defp thumbnails(images, index) do
    images
    |> Enum.with_index()
    |> List.pop_at(index)
    |> elem(1)
  end

  defp contact(assigns) do
    ~H"""
    <div class="flex flex-col gap-y-4">
      <h2 class="font-manrope font-bold xl:text-2xl">Interesuje Cię adopcja?</h2>
      <p class="text-lg">
        Wypełnij
        <a href="#" class="text-primary font-bold underline underline-offset-4">
          ankietę adopcyjną
        </a>
      </p>
      <p class="text-lg">Kotem opiekuje się <b>Agnieszka</b></p>
      <h4 class="text-primary font-bold text-lg">Telefon do opiekuna</h4>
      <div class="flex space-x-2">
        <.button
          href="#"
          type="outline"
          class="!px-4 !py-1.5 text-black font-normal xl:text-sm flex gap-x-1.5 align-center"
        >
          <.icon name="telephone" /><span>123 456 789</span>
        </.button>
        <.button
          href="#"
          type="outline"
          class="!px-4 !py-1.5 text-black font-normal xl:text-sm flex gap-x-1.5 align-center"
        >
          <.icon name="telephone" /><span>123 456 789</span>
        </.button>
      </div>
    </div>
    """
  end

  defp cat_gallery(assigns) do
    ~H"""
    <%= if @images != [] do %>
      <div class="flex flex-col gap-y-2 min-w-[868px] ">
        <.gallery_image image={Enum.at(@images, @current_image)} />
        <div :if={length(@images) > 1} class="flex gap-x-2">
          <%= for {image, n} <- thumbnails(@images, @current_image) do %>
            <button phx-click="set-image" value={n}>
              <.gallery_thumbnail image={image} />
            </button>
          <% end %>
        </div>
      </div>
    <% else %>
      <.gallery_empty />
    <% end %>
    """
  end

  defp cat_info(assigns) do
    ~H"""
    <div class="flex flex-col space-y-6">
      <h2 class="font-manrope font-extrabold xl:text-3xl">Informacje o kocie</h2>

      <ul class="flex flex-col gap-y-4 font-bold font-manrope text-xl 2xl:whitespace-nowrap">
        <li class="flex align-center gap-x-4">
          <.icon name="gender" class="w-5" /><%= Cat.Sex.to_string(@cat.sex) %>
        </li>
        <li class="flex align-center gap-x-4">
          <.icon name="paw" class="w-5" /><%= Cat.Age.to_string(@cat.age) %>
        </li>
        <li class="flex align-center gap-x-4">
          <.icon name="sthetoscope" class="w-5" />
          <%= Cat.MedicalStatus.to_string(@cat.medical_status) %>
        </li>
        <li class="flex align-center gap-x-4">
          <.icon name="scissors" class="w-5" />
          <%= Cat.Castrated.to_string(@cat.castrated) %>
        </li>
        <li class="flex align-center gap-x-4">
          <.icon name="ekg" class="w-5" />
          <%= Cat.Healthy.to_string(@cat.healthy) %>
        </li>
        <li class="flex align-center gap-x-4">
          <.icon name="medicine" class="w-3 mx-1" />
          <%= Cat.FivFelv.to_string(@cat.fiv_felv) %>
        </li>
      </ul>

      <div class="flex flex-row flex-wrap gap-x-2 gap-y-8">
        <%= for text <- @cat.tags do %>
          <div class="w-auto h-auto">
            <.card_tag><%= text %></.card_tag>
          </div>
        <% end %>
      </div>
      <.button href="#">Udostępnij znajomym</.button>
    </div>
    """
  end
end
