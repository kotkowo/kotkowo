defmodule Kotkowo.Cat.Age do
  defstruct [:value]

  @type age :: :junior | :adult | :senior
  @type t :: %__MODULE__{value: age()}

  defimpl String.Chars, for: __MODULE__ do
    def to_string(%_{value: :junior}), do: "Junior"
    def to_string(%_{value: :adult}), do: "Dorosły"
    def to_string(%_{value: :senior}), do: "Senior"
  end
end
