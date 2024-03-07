defmodule KotkowoWeb.HomeLive.Index do
  @moduledoc false

  use KotkowoWeb, :live_view

  import KotkowoWeb.Components.Steps

  alias Kotkowo.GalleryImage
  alias Kotkowo.StrapiClient

  require Logger

  @impl true
  def mount(_params, _session, socket) do
    news =
      case StrapiClient.list_announcements(3) do
        {:ok, news} ->
          news

        {:error, {_reason, message}} ->
          Logger.error(message)
          :error
      end

    in_need_of_a_new_home =
      case StrapiClient.list_adopted_cats(3) do
        {:ok, result} ->
          result

        {:error, {_reason, message}} ->
          Logger.error(message)
          :error
      end

    socket =
      socket
      |> assign(:news, news)
      |> assign(:in_need_of_a_new_home, in_need_of_a_new_home)

    {:ok, socket}
  end
end
