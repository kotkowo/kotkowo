defmodule Kotkowo.Client.Image do
  @moduledoc false
  defstruct [:id, :name, :width, :height, :url, :mime, :alternative_text, :preview_url]
  @default_image "/images/cat_placeholder.jpg"
  @type t() :: %__MODULE__{
          id: String.t() | nil,
          name: String.t() | nil,
          width: pos_integer(),
          height: pos_integer(),
          url: String.t() | nil,
          mime: String.t() | nil,
          alternative_text: String.t() | nil,
          preview_url: String.t() | nil
        }
  def first_url(gallery, default \\ @default_image)
  def first_url([first | _], _default), do: first.url
  def first_url([], default), do: default
end
