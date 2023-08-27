defmodule KotkowoWeb.PageHTML do
  @moduledoc false
  use KotkowoWeb, :html

  import KotkowoWeb.Components.Buttons
  import KotkowoWeb.Components.Cards
  import KotkowoWeb.Components.Drawers
  import KotkowoWeb.Components.Icons
  import KotkowoWeb.Components.Notifiers
  import KotkowoWeb.Components.Sections
  import KotkowoWeb.Components.Static.HelpProposalSection
  import KotkowoWeb.Components.Static.HowYouCanHelpSection
  import KotkowoWeb.Components.Steps

  embed_templates "page_html/*"
end
