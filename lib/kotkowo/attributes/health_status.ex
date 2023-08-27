defmodule Kotkowo.Attributes.HealthStatus do
  @moduledoc false

  import KotkowoWeb.Gettext

  def all, do: [:examined_and_vaccinated]

  def to_string(:examined_and_vaccinated), do: gettext("Przebadany i zaszczepiony")
end
