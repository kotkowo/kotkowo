defmodule Kotkowo.Client.Cat.Age do
  @moduledoc false
  @all [:junior, :adult, :senior]
  @type t() :: unquote(TypeUtils.list_to_typespec(@all))

  @spec to_string(t()) :: String.t()
  def to_string(:junior), do: "junior"
  def to_string(:adult), do: "dorosły"
  def to_string(:senior), do: "senior"

  for age <- @all do
    def from_string(unquote(to_string(age))), do: unquote(age)
  end

  def from_string(_), do: nil

  @spec all() :: [t()]
  def all, do: @all
end
