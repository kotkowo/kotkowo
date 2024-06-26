defmodule Kotkowo.Client.ContactInformation do
  @moduledoc false
  defstruct [
    :first_name,
    :last_name,
    :phone_number
  ]

  @type t() :: %__MODULE__{
          first_name: String.t(),
          last_name: String.t(),
          phone_number: String.t()
        }
end
