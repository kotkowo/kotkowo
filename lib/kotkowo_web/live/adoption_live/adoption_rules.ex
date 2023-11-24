defmodule KotkowoWeb.AdoptionLive.AdoptionRules do
  @moduledoc false
  use KotkowoWeb, :live_view

  import KotkowoWeb.Components.Static.HowYouCanHelpSection
  import KotkowoWeb.Components.Steps

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
