defmodule Kotkowo.GalleryImage do
  defstruct [:hash, :ext, :name, :alternative_text]

  @type t :: %__MODULE__{
          hash: String.t(),
          ext: String.t() | nil,
          name: String.t(),
          alternative_text: String.t() | nil
        }

  def url(gallery_image, size \\ :default)

  def url(%__MODULE__{} = gallery_image, :default) do
    "http://localhost:1337/uploads/#{gallery_image.hash}#{gallery_image.ext}"
  end

  def url(%__MODULE__{} = gallery_image, :thumbnail) do
    "http://localhost:1337/uploads/thumbnail_#{gallery_image.hash}#{gallery_image.ext}"
  end
end
