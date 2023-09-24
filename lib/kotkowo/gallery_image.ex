defmodule Kotkowo.GalleryImage do
  @moduledoc false
  defstruct [:hash, :ext, :name, :alternative_text]

  @type t :: %__MODULE__{
          hash: String.t(),
          ext: String.t() | nil,
          name: String.t(),
          alternative_text: String.t() | nil
        }

  def url(gallery_image, size \\ :default)

  def url(%__MODULE__{} = gallery_image, :default) do
    filename = "#{gallery_image.hash}#{gallery_image.ext}"
    get_upload_url(filename)
  end

  def url(%__MODULE__{} = gallery_image, :thumbnail) do
    filename = "thumbnail_#{gallery_image.hash}#{gallery_image.ext}"
    get_upload_url(filename)
  end

  defp get_upload_url(filename) do
    :kotkowo
    |> Application.get_env(:strapi)
    |> Keyword.get(:endpoint)
    |> URI.parse()
    |> Map.put(:path, "/uploads/#{filename}")
    |> to_string()
  end
end
