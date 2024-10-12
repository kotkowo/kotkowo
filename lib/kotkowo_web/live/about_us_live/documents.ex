defmodule KotkowoWeb.AboutUsLive.Documents do
  @moduledoc false
  use KotkowoWeb, :live_view

  import KotkowoWeb.Components.Static.HowYouCanHelpSection
  import KotkowoWeb.Constants

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
