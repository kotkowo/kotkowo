defmodule Kotkowo.Attributes.Sex do
  @moduledoc false
  import KotkowoWeb.Gettext

  def all, do: [:male, :female]

  def to_string(:male), do: gettext("Kocur")
  def to_string(:female), do: gettext("Kotka")
end
