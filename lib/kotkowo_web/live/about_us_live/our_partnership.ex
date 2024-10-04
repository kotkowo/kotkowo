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
      <h2 class="font-bold text-2xl text-primary"><%= @title %></h2>
      <p class="text-base font-inter"><%= @body %></p>
    </div>
    """
  end

  attr :asset, :string

  defp assets_box(assigns) do
    ~H"""
    <div class="flex flex-col min-w-[246px] w-[246px] snap-center">
      <div class="bg-primary-light h-[158px] rounded-t-2xl w-full">
        <img class="w-full h-full object-fit" src={~p"/images/#{@asset}"} alt={@asset} />
      </div>
      <div class="px-4 items-center flex flex-row justify-between bg-white h-[60px] border-b-2 border-x-2 border-gray-200 rounded-b-2xl rounded-x-2xl w-full">
        <span><%= @asset %></span>
        <a download href={~p"/images/#{@asset}"} target="_blank" rel="noopener noreferrer">
          <.icon name="download" class="w-4 text-black" />
        </a>
      </div>
    </div>
    """
  end
end
