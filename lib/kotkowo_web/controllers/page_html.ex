defmodule KotkowoWeb.PageHTML do
  @moduledoc false
  use KotkowoWeb, :html

  import KotkowoWeb.Components.Cards
  import KotkowoWeb.Components.Buttons
  import KotkowoWeb.Components.Sections
  import KotkowoWeb.Components.Steps
  import KotkowoWeb.Components.Icons
  import KotkowoWeb.Components.Static.HowYouCanHelpSection

  embed_templates "page_html/*"
end
