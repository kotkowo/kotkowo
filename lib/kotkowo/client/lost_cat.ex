defmodule Kotkowo.Client.LostCat do
  @moduledoc false
  alias Kotkowo.Client.Cat

  defstruct [
    :id,
    :disappearance_location,
    :disappearance_circumstances,
    :special_signs,
    :during_medical_treatment,
    :disappearance_datetime,
    :cat
  ]

  @type t() :: %__MODULE__{
          id: String.t() | nil,
          cat: Cat.t(),
          disappearance_location: String.t(),
          disappearance_circumstances: String.t(),
          during_medical_treatment: boolean(),
          disappearance_datetime: Kotkowo.Client.DateTime.t(),
          special_signs: String.t() | nil
        }
end
