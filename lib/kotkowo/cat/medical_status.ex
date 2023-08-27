defmodule Kotkowo.Cat.MedicalStatus do
  @moduledoc false
  defstruct [:value]

  @type medical_status :: :tested_and_vaccinated
  @type t :: %__MODULE__{value: medical_status()}

  defimpl String.Chars, for: __MODULE__ do
    def to_string(%_{value: :tested_and_vaccinated}), do: "Przebadany i zaszczepiony"
  end
end
