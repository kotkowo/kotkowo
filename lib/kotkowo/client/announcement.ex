defmodule Kotkowo.Client.Announcement do
  @moduledoc false

  alias Kotkowo.Client.Image

  @type tags() :: [String.t()]

  defstruct [
    :id,
    :title,
    :tags,
    :image
  ]

  @type t() :: %__MODULE__{
          id: String.t() | nil,
          tags: tags(),
          title: String.t(),
          image: Image.t() | nil
        }
end
