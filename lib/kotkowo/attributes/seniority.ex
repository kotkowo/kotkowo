defmodule Kotkowo.Attributes.Seniority do
  @moduledoc false

  import KotkowoWeb.Gettext

  def all, do: [:senior, :adult, :junior]

  def to_string(:senior), do: gettext("Senior")
  def to_string(:adult), do: gettext("Dorosły")
  def to_string(:junior), do: gettext("Junior")
end
