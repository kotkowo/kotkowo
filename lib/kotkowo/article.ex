defmodule Kotkowo.Article do
  @moduledoc false

  @type t :: %__MODULE__{
          introduction: String.t(),
          image: GalleryImage,
          content: String.t()
        }
  defstruct [
    :introduction,
    :image,
    :content
  ]
end
