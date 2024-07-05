defmodule Kotkowo.Client.FoundCat do
  @moduledoc false
  alias Kotkowo.Client.Cat

  defstruct [
    :id,
    :found_location,
    :discovery_circumstances,
    :special_signs,
    :found_datetime,
    :cat
  ]

  @type t() :: %__MODULE__{
          id: String.t() | nil,
          cat: Cat.t(),
          found_location: String.t(),
          discovery_circumstances: String.t(),
          found_datetime: Kotkowo.Client.DateTime.t(),
          special_signs: String.t() | nil
        }
end
