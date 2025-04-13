defmodule KotkowoWeb.AboutUsLive.AboutFundation do
  @moduledoc false
  use KotkowoWeb, :live_view

  import KotkowoWeb.Components.Static.HowYouCanHelpSection
  import KotkowoWeb.Components.Static.RulesetSection

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  attr(:title, :string)
  attr(:icon, :string)
  attr(:content, :string)

  defp whats_our_role(assigns) do
    ~H"""
    <div class="flex flex-col gap-y-3">
      <div class="text-primary font-bold text-lg flex flex-row items-center gap-x-2">
        <.icon name={@icon} class="w-7" />
        <h3>{@title}</h3>
      </div>
      <p>{@content}</p>
    </div>
    """
  end

  attr(:content, :string)
  attr(:portrait, :string)
  attr(:name, :string)

  defp opinion(assigns) do
    ~H"""
    <div class="relative snap-center h-[289px] md:h-[269px] flex items-end justify-center">
      <div class="absolute top-0 flex flex-col gap-y-2">
        <img src={@portrait} class="rounded-full w-20 h-20 object-cover overflow-visible" />
        <span class="text-gray-600 text-center">{@name}</span>
      </div>
      <div class="flex text-center flex-col items-center border-gray-50 rounded-2xl md:w-[600px] md:h-[229px] h-[246px] w-[300px] border-4">
        <.icon name="double_quote" class="w-9 self-end absolute mr-4 mt-3" />
        <p class="w-[260px] md:w-[552px] mt-20 mx-1 font-itern tracking-wider italic text-sm md:text-base overflow-y-auto">
          {@content}
        </p>
      </div>
    </div>
    """
  end
end
