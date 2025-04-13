defmodule KotkowoWeb.AboutUsLive.OurPartnership do
  @moduledoc false
  use KotkowoWeb, :live_view

  import KotkowoWeb.Components.Static.HowYouCanHelpSection
  import KotkowoWeb.Constants

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  attr :icon, :string
  attr :title, :string
  attr :body, :string

  defp benefit(assigns) do
    ~H"""
    <div class="flex flex-col bg-white md:h-[242px] gap-y-3 rounded-2xl p-6">
      <.icon name={@icon} class="w-7" />
      <h2 class="font-bold text-2xl text-primary">{@title}</h2>
      <p class="text-base font-inter">{@body}</p>
    </div>
    """
  end
end
