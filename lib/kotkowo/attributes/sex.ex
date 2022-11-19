defmodule Kotkowo.Attributes.Sex do
  @moduledoc false

  def all(), do: [:male, :female]

  def to_string(:male), do: raise(UndefinedFunctionError)
  def to_string(:female), do: raise(UndefinedFunctionError)
end
