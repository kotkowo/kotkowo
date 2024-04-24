defmodule Kotkowo.Client.Cat.Sex do
  @moduledoc false

  @all [:male, :female]
  @type t() :: unquote(TypeUtils.list_to_typespec(@all))

  @spec to_string(t()) :: String.t()
  def to_string(:male), do: "Kot"
  def to_string(:female), do: "Kotka"

  for sex <- @all do
    def from_string(unquote(to_string(sex))), do: unquote(sex)
  end

  def from_string(_), do: nil

  @spec all() :: [t()]
  def all, do: @all
end
