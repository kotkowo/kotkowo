defmodule Kotkowo.Attributes.HealthStatus do
  @moduledoc false

  import KotkowoWeb.Gettext

  def all, do: [:tested_and_vaccinated]

  def to_string(:tested_and_vaccinated), do: gettext("Przebadany i zaszczepiony")
end
