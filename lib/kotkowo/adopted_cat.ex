defmodule Kotkowo.AdoptedCat do
  @moduledoc false
  alias Kotkowo.Cat

  defstruct [:cat, :adoption_date, :id]

  @type t :: %__MODULE__{
          id: pos_integer(),
          cat: Cat
        }
end
