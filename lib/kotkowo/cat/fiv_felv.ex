defmodule Kotkowo.Cat.FivFelv do
  defstruct [:value]

  @type fiv_felv :: :positive | :negative
  @type t :: %__MODULE__{value: fiv_felv()}

  defimpl String.Chars, for: __MODULE__ do
    def to_string(%_{value: :positive}), do: "Testy FIV/FELV pozytywne"
    def to_string(%_{value: :negative}), do: "Testy FIV/FELV negatywne"
  end
end
