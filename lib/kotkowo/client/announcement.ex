defmodule Kotkowo.Client.Announcement do
  @moduledoc false

  alias Kotkowo.Client.Image

  @type tags() :: [String.t()]

  defstruct [
    :id,
    :title,
    :image
  ]

  @type t() :: %__MODULE__{
          id: String.t() | nil,
          title: String.t(),
          image: Image.t() | nil
        }
end
