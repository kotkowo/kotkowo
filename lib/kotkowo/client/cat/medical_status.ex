defmodule Kotkowo.Client.Cat.MedicalStatus do
  @moduledoc false
  @all [:tested_and_vaccinated]
  @type t() :: unquote(TypeUtils.list_to_typespec(@all))

  @spec to_string(t()) :: String.t()
  def to_string(:tested_and_vaccinated), do: "Przebadany i zaszczepiony"

  for status <- @all do
    def from_string(unquote(to_string(status))), do: unquote(status)
  end

  def from_string(_), do: nil

  @spec all() :: [t()]
  def all, do: @all
end
