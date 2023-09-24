defmodule Kotkowo.Announcement do
  @moduledoc false
  alias Kotkowo.GalleryImage

  @type t :: %__MODULE__{
          title: String.t(),
          image: GalleryImage,
          tags: [String.t()],
          id: pos_integer()
        }
  defstruct [:title, :image, :tags, :id]
end
