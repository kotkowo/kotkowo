defmodule KotkowoWeb.Components.CatGallery do
  @moduledoc false
  use Phoenix.LiveComponent

  import KotkowoWeb.Components.CatViewUtils
  import KotkowoWeb.Components.Icons
  import KotkowoWeb.Components.Images
  import Tails, only: [classes: 1]

  def handle_event("set-image", %{"value" => index}, socket) do
    last = max(length(socket.assigns.images) - 1, 0)

    index =
      case Integer.parse(index) do
        {n, _} ->
          cond do
            n < 0 -> last
            n in 0..last -> n
            true -> 0
          end

        _ ->
          0
      end

    {:noreply,
     push_patch(socket,
       to: "#{socket.assigns.path}?image=#{index}",
       replace: true
     )}
  end

  attr :class, :string, default: ""
  attr :img_class, :string, default: ""

  def render(assigns) do
    ~H"""
    <div>
      <div class="xl:hidden lg:block flex justify-center">
        <%= if @images != [] do %>
          <div
            x-init="$el.scrollLeft = ($el.scrollWidth - $el.clientWidth) / 2;"
            class="flex flex-row overflow-x-auto snap-x gap-2 ml-auto"
          >
            <%= for img <- @images do %>
              <img
                src={img.url}
                alt={img.alternative_text}
                class="first:ml-4 last:mr-4 mx-auto snap-center min-w-[280px] w-[280px] min-h-[156px] h-[156px] object-cover"
              />
            <% end %>
          </div>
        <% else %>
          <.gallery_empty />
        <% end %>
      </div>
      <div class="xl:block hidden">
        <%= if @images != [] do %>
          <div class={classes(["flex flex-col gap-y-2 min-w-[868px]", @class])}>
            <div class="relative">
              <button
                :if={length(@images) > 1}
                phx-click="set-image"
                phx-target={@myself}
                value={@current_image - 1}
                class="cursor-pointer rounded-full flex justify-center items-center bg-white/50 w-10 h-10 absolute left-2 top-1/2 -translate-y-1/2"
              >
                <.icon name="chevron_down" class="rotate-90 -translate-x-0.5" />
              </button>
              <.gallery_image class={@img_class} image={Enum.at(@images, @current_image)} />

              <button
                :if={length(@images) > 1}
                phx-click="set-image"
                phx-target={@myself}
                value={@current_image + 1}
                class="cursor-pointer rounded-full flex justify-center items-center bg-white/50 w-10 h-10 absolute right-2 top-1/2 -translate-y-1/2"
              >
                <.icon name="chevron_up" class="rotate-90 translate-x-0.5" />
              </button>
            </div>
            <div :if={length(@images) > 1} class="flex gap-x-2">
              <%= for {image, n} <- thumbnails(@images, @current_image) do %>
                <button phx-target={@myself} phx-click="set-image" value={n}>
                  <.gallery_thumbnail image={image} />
                </button>
              <% end %>
            </div>
          </div>
        <% else %>
          <.gallery_empty />
        <% end %>
      </div>
    </div>
    """
  end
end
