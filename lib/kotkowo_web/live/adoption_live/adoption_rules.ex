defmodule KotkowoWeb.AdoptionLive.AdoptionRules do
  @moduledoc false
  use KotkowoWeb, :live_view

  import KotkowoWeb.Components.Static.HowYouCanHelpSection
  import KotkowoWeb.Components.Steps
  import KotkowoWeb.Constants

  alias Kotkowo.Client
  alias Kotkowo.Client.Cat
  alias Kotkowo.Client.Image
  alias Kotkowo.Client.Paged

  require Logger

  def handle_async(:load_cats, {:ok, cats}, socket) do
    socket =
      case cats do
        {:ok, %Paged{items: cats}} ->
          assign(socket, :in_need_of_a_new_home, cats)

        {:error, message} ->
          Logger.error(message)
          assign(socket, :in_need_of_a_new_home, :error)
      end

    {:noreply, socket}
  end

  def mount(_params, _session, socket) do
    default_filter =
      Map.put(%Cat.Filter{}, :is_dead, false)

    socket =
      socket
      |> assign(:in_need_of_a_new_home, [])
      |> start_async(:load_cats, fn ->
        [page: 1, page_size: 3, filter: default_filter] |> Client.new() |> Client.list_looking_for_adoption_cats()
      end)

    {:ok, socket}
  end
end
