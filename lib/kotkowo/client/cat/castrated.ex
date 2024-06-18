defmodule Kotkowo.Client.Cat.Castrated do
  @moduledoc false
  @type t() :: boolean()

  @spec to_string(t()) :: String.t()
  def to_string(true), do: "Po kastracji"
  def to_string(false), do: "Przed kastracją"

  def from_string(unquote(to_string(true))), do: unquote(true)
  def from_string(unquote(to_string(false))), do: unquote(false)

  def from_string(_), do: nil
end
