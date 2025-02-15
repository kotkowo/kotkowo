defmodule Kotkowo.Client.Article do
  @moduledoc false

  alias Kotkowo.Client.Image

  @type tags() :: [String.t()]
  defstruct [
    :id,
    :introduction,
    :content,
    :image,
    :tags
  ]

  @type t() :: %__MODULE__{
          id: String.t() | nil,
          introduction: String.t(),
          content: String.t(),
          image: Image.t() | nil,
          tags: tags()
        }
end
