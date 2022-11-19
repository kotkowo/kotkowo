defmodule KotkowoWeb.Components.Icons do
  @moduledoc """
  Provides card UI components.
  """

  use Phoenix.Component

  use Phoenix.VerifiedRoutes,
    endpoint: KotkowoWeb.Endpoint,
    router: KotkowoWeb.Router,
    statics: ~w(images)

  import KotkowoWeb.Gettext

  attr :rest, :global

  def icon_male(assigns) do
    ~H"""
    <img src={~p"/images/male.svg"} alt={gettext("Male")} {@rest} />
    """
  end

  attr :rest, :global

  def icon_female(assigns) do
    ~H"""
    <img src={~p"/images/female.svg"} alt={gettext("Female")} {@rest} />
    """
  end

  attr :rest, :global

  def icon_paw(assigns) do
    ~H"""
    <img src={~p"/images/paw.svg"} alt={gettext("Paw")} {@rest} />
    """
  end

  attr :rest, :global

  def icon_sthetoscope(assigns) do
    ~H"""
    <img src={~p"/images/sthetoscope.svg"} alt={gettext("Sthetoscope")} {@rest} />
    """
  end

  attr :rest, :global

  def icon_scissors(assigns) do
    ~H"""
    <img src={~p"/images/scissors.svg"} alt={gettext("Scissors")} {@rest} />
    """
  end

  attr :rest, :global

  def icon_share(assigns) do
    ~H"""
    <img src={~p"/images/share.svg"} alt={gettext("Share")} {@rest} />
    """
  end

  attr :rest, :global

  def icon_envelope(assigns) do
    ~H"""
    <img src={~p"/images/envelope.svg"} alt={gettext("Envelope")} {@rest} />
    """
  end

  attr :rest, :global

  def icon_facebook(assigns) do
    ~H"""
    <img src={~p"/images/facebook.svg"} alt={gettext("Envelope")} {@rest} />
    """
  end

  attr :rest, :global

  def icon_bars(assigns) do
    ~H"""
    <img src={~p"/images/bars.svg"} alt={gettext("Envelope")} {@rest} />
    """
  end

  attr :rest, :global

  def icon_messenger(assigns) do
    ~H"""
    <img src={~p"/images/messenger.svg"} alt={gettext("Messenger")} {@rest} />
    """
  end

  attr :rest, :global

  def icon_chevron_up(assigns) do
    ~H"""
    <img src={~p"/images/chevron_up.svg"} alt={gettext("Up")} {@rest} />
    """
  end

  attr :rest, :global

  def icon_chevron_down(assigns) do
    ~H"""
    <img src={~p"/images/chevron_down.svg"} alt={gettext("Down")} {@rest} />
    """
  end
end
