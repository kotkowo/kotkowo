defmodule KotkowoWeb.Components.Icons do
  @moduledoc """
  Provides card UI components.
  """

  use KotkowoWeb, :verified_routes
  use Phoenix.Component

  @all ~w(arrow_right male female paw sthetoscope scissors share envelope facebook bars messenger chevron_up chevron_down city_scraper envelope2 messenger_black facebook_outline eraser recycle medicine droplet bag fish round_container cookie clipboard_done telephone ekg gender)

  attr :name, :string, values: @all

  attr :rest, :global

  def icon(assigns) do
    ~H"""
    <img src={~p"/images/#{@name <> ".svg"}"} alt={@name} {@rest} />
    """
  end

  def icons_all, do: @all
end
