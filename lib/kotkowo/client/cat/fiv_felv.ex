defmodule Kotkowo.Client.Cat.FivFelv do
  @moduledoc false
  @all [:positive, :negative]
  @type t() :: unquote(TypeUtils.list_to_typespec(@all))

  @spec to_string(t()) :: String.t()

  def to_string(:positive), do: "Testy FIV/FELV pozytywne"
  def to_string(:negative), do: "Testy FIV/FELV negatywne"

  for status <- @all do
    def from_string(unquote(to_string(status))), do: unquote(status)
  end

  def from_string(_), do: nil

  @spec all() :: [t()]
  def all, do: @all
end
