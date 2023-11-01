defmodule KotkowoWeb.NewsLive.FoundHome do
  @moduledoc false
  use KotkowoWeb, :live_view
  alias Kotkowo.GalleryImage
  import KotkowoWeb.Components.Static.HowYouCanHelpSection
alias Kotkowo.StrapiClient
  @impl true
  def mount(_params, _session, socket) do
    {:ok, adopted_cats} = StrapiClient.list_adopted_cats()
    socket = assign(socket, :adopted_cats, adopted_cats)
    {:ok, socket}
  end
end
