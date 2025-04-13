defmodule Kotkowo.Client.Advice do
  @moduledoc false
  alias Kotkowo.Client.Image

  defstruct [
    :id,
    :title,
    :image,
    :tags,
    :views
  ]

  @type tags() :: [String.t()]
  @type t() :: %__MODULE__{
          id: String.t(),
          title: String.t(),
          image: Image.t(),
          tags: tags(),
          views: integer()
        }
end
