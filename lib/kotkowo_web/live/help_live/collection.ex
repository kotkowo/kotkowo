defmodule KotkowoWeb.HelpLive.Collection do
  @moduledoc false

  use KotkowoWeb, :live_view

  import KotkowoWeb.Components.Static.HowYouCanHelpSection
  import KotkowoWeb.Components.Steps
  import KotkowoWeb.Constants, only: [kotkowo_mail: 0]
end
