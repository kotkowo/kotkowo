defmodule KotkowoWeb.Components.Images do
  @moduledoc false

  use KotkowoWeb, :verified_routes
  use Phoenix.Component

  import Tails, only: [classes: 1]

  attr :image, :any, doc: "Image.t()"
  attr :class, :string, default: ""

  def gallery_image(assigns) do
    ~H"""
    <picture>
      <source media="(max-width: 799px)" srcset={@image.url} />
      <img
        class={
          classes([
            "lg:w-[868px] lg:h-[485px] lg:max-w-[868px] lg:max-h-[485px] lg:min-w-[868px] lg:min-h-[485px] object-cover",
            @class
          ])
        }
        src={@image.url}
        alt={@image.alternative_text}
      />
    </picture>
    """
  end

  def gallery_empty(assigns) do
    ~H"""
    <div class="flex lg:w-[868px] lg:h-[485px] w-[340px] h-[225px] object-cover bg-gray-200">
      <Heroicons.x_mark class="w-32 h-32 m-auto" />
    </div>
    """
  end

  attr :image, :any, doc: "Image.t()"

  def gallery_thumbnail(assigns) do
    ~H"""
    <img class="w-[80px] h-[45px] object-cover" src={@image.url} />
    """
  end
end
