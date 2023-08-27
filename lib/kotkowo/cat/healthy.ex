defmodule Kotkowo.Cat.Healthy do
  defstruct [:value]

  @type t :: %__MODULE__{value: boolean()}

  defimpl String.Chars, for: __MODULE__ do
    def to_string(%_{value: true}), do: "Zdrowy"
    def to_string(%_{value: false}), do: "Wymaga opieki"
  end
end
