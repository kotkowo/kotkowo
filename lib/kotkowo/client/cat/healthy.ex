defmodule Kotkowo.Client.Cat.Healthy do
  @moduledoc false

  @type t() :: boolean()

  @spec to_string(t()) :: String.t()

  def to_string(true), do: "Zdrowy"
  def to_string(false), do: "Wymaga opieki"

  def from_string("Zdrowy"), do: true
  def from_string("Wymaga opieki"), do: false

  def from_string(_), do: nil
end
