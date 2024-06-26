defmodule Kotkowo.Client.LookingForHomeCat do
  @moduledoc false
  alias Kotkowo.Client.Cat
  alias Kotkowo.Client.ContactInformation

  defstruct [
    :id,
    :caretaker,
    :cat
  ]

  @type t() :: %__MODULE__{
          id: String.t() | nil,
          caretaker: ContactInformation.t() | nil,
          cat: Cat.t()
        }
end
