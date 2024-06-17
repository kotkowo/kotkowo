defmodule KotkowoWeb.Components.Images do
  @moduledoc false

  use KotkowoWeb, :verified_routes
  use Phoenix.Component

  alias Kotkowo.Client.Image

  attr :image, :any, doc: "Image.t()"

  def gallery_image(assigns) do
    assigns = assign(assigns, :image_default, assigns.image.url)

    ~H"""
    <picture>
      <source media="(max-width: 799px)" srcset={@image_default} />
      <img
        class="w-[868px] h-[485px] max-w-[868px] max-h-[485px] min-w-[868px] min-h-[485px] object-cover"
        src={@image_default}
        alt={@image.alternative_text}
      />
    </picture>
    """
  end

  def gallery_empty(assigns) do
    ~H"""
    <div class="flex w-[868px] h-[485px] object-cover bg-gray-200">
      <Heroicons.x_mark class="w-32 h-32 m-auto" />
    </div>
    """
  end

  attr :image, :any, doc: "Image.t()"

  def gallery_thumbnail(assigns) do
    assigns = assign(assigns, :thumbnail, Image.first_url(assigns.image, :thumbnail))

    ~H"""
    <img class="w-[80px] h-[45px] object-cover" src={@thumbnail} />
    """
  end
end
