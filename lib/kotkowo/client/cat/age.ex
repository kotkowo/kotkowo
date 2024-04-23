defmodule Kotkowo.Client.Cat.Age do
  @moduledoc false
  @all [:junior, :adult, :senior]
  @type t() :: unquote(TypeUtils.list_to_typespec(@all))

  @spec to_string(t()) :: String.t()
  def to_string(:junior), do: "junior"
  def to_string(:adult), do: "dorosły"
  def to_string(:senior), do: "senior"

  @spec all() :: [t()]
  def all, do: @all
end
