defmodule Kotkowo.Cat.Castrated do
  @moduledoc false
  defstruct [:value]

  @type t :: %__MODULE__{value: boolean()}

  defimpl String.Chars, for: __MODULE__ do
    def to_string(%_{value: true}), do: "Po kastracji"
    def to_string(%_{value: false}), do: "Przed kastracją"
  end
end
