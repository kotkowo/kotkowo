defmodule Kotkowo.Cat.Color do
  @moduledoc false
  defstruct [:value]

  @type color :: :ginger | :black | :gray | :tricolor | :other | :patched
  @type t :: %__MODULE__{value: color()}

  defimpl String.Chars, for: __MODULE__ do
    def to_string(%_{value: :ginger}), do: "rudy"
    def to_string(%_{value: :black}), do: "czarny"
    def to_string(%_{value: :tricolor}), do: "tricolor"
    def to_string(%_{value: :gray}), do: "szaro-bury"
    def to_string(%_{value: :patched}), do: "łaciaty"
    def to_string(%_{value: :other}), do: "inny"
  end
end
