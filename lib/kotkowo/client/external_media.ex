defmodule Kotkowo.Client.ExternalMedia do
  @moduledoc false

  alias Kotkowo.Client.Image

  @type tags() :: [String.t()]

  defstruct [
    :id,
    :title,
    :media_url,
    :tags,
    :image
  ]

  @type t() :: %__MODULE__{
          id: String.t() | nil,
          title: String.t(),
          tags: tags(),
          media_url: String.t(),
          image: Image.t() | nil
        }
end
