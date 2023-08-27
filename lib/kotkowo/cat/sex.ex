defmodule Kotkowo.Cat.Sex do
  defstruct [:value]

  @type sex :: :male | :female
  @type t :: %__MODULE__{value: sex()}

  defimpl String.Chars, for: __MODULE__ do
    def to_string(%_{value: :male}), do: "Kot"
    def to_string(%_{value: :female}), do: "Kotka"
  end
end
