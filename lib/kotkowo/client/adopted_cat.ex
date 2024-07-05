defmodule Kotkowo.Client.AdoptedCat do
  @moduledoc false
  alias Kotkowo.Client.Cat

  defstruct [
    :id,
    :adoption_date,
    :cat
  ]

  @type t() :: %__MODULE__{
          id: String.t() | nil,
          cat: Cat.t(),
          adoption_date: Kotkowo.Client.DateTime.t()
        }
end
