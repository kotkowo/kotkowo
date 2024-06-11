defmodule Kotkowo.Client.BetweenDateTime do
  @moduledoc false
  defstruct [
    :date_from,
    :date_to
  ]

  @type t() :: %__MODULE__{
          date_from: String.t() | nil,
          date_to: String.t() | nil
        }
end
