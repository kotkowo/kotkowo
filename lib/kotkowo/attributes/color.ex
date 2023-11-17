defmodule Kotkowo.Attributes.Color do
  @moduledoc false
  import KotkowoWeb.Gettext

  def all, do: [:ginger, :black, :gray, :tricolor, :other, :patched]

  def to_string(:ginger), do: gettext("rudy")
  def to_string(:black), do: gettext("czarny")
  def to_string(:tricolor), do: gettext("tricolor")
  def to_string(:gray), do: gettext("szaro-bury")
  def to_string(:patched), do: gettext("łaciaty")
  def to_string(:other), do: gettext("inny")
end
