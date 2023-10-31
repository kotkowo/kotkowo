defmodule KotkowoWeb.NewsLive.FoundHome do
  @moduledoc false
  use KotkowoWeb, :live_view

  import KotkowoWeb.Components.Static.HowYouCanHelpSection

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
