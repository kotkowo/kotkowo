defmodule KotkowoWeb.Components.Icons do
  @moduledoc """
  Provides card UI components.
  """

  use Phoenix.Component

  use Phoenix.VerifiedRoutes,
    endpoint: KotkowoWeb.Endpoint,
    router: KotkowoWeb.Router,
    statics: ~w(images)

  @all ~w(male female paw sthetoscope scissors share envelope facebook bars messenger chevron_up chevron_down)

  attr :name, :string, values: @all

  attr :rest, :global

  def icon(assigns) do
    ~H"""
    <img src={~p"/images/#{@name <> ".svg"}"} alt={@name} {@rest} />
    """
  end

  def icons_all(), do: @all
end
