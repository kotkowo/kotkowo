defmodule KotkowoWeb.AdoptionLive.AdoptionRules do
  @moduledoc false
  use KotkowoWeb, :live_view

  import KotkowoWeb.Components.Static.HowYouCanHelpSection
  import KotkowoWeb.Components.Steps

  alias Kotkowo.GalleryImage
  alias Kotkowo.StrapiClient

  def mount(_params, _session, socket) do
    {:ok, in_need_of_a_new_home} = StrapiClient.list_adopted_cats(3)
    socket = assign(socket, :in_need_of_a_new_home, in_need_of_a_new_home)
    {:ok, socket}
  end
end
