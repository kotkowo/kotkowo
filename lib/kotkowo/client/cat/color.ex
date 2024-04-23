defmodule Kotkowo.Client.Cat.Color do
  @moduledoc false
  @all [:black, :gray, :tricolor, :patched, :ginger, :other_color]
  @type t() :: unquote(TypeUtils.list_to_typespec(@all))

  @spec to_string(t()) :: String.t()
  def to_string(:black), do: "czarny"
  def to_string(:gray), do: "szary"
  def to_string(:tricolor), do: "tricolor"
  def to_string(:ginger), do: "rudy"
  def to_string(:patched), do: "łaciaty"
  def to_string(:other_color), do: "inny"

  @spec all() :: [t()]
  def all, do: @all
end
