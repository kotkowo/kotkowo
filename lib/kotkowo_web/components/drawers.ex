defmodule KotkowoWeb.Components.Drawers do
  @moduledoc """
  Provides card UI components.
  """

  use KotkowoWeb, :verified_routes
  use Phoenix.Component

  import KotkowoWeb.Components.Icons

  attr :title, :string, required: true
  slot :inner_block, required: true, doc: "Content when unfolded"

  def drawer(assigns) do
    ~H"""
    <div
      class="border border-2 rounded-xl xl:w-[757px] flex flex-col cursor-pointer select-none"
      x-data="{folded: true}"
    >
      <div
        class="p-6 flex justify-between align-center"
        x-bind:class="!folded && 'pb-3'"
        x-on:click="folded = !folded"
      >
        <span class="font-bold xl:text-xl"><%= @title %></span>
        <template x-if="folded">
          <.icon name="chevron_down" class="w-4 lg:w-5 h-3 lg:h-4 my-auto" />
        </template>
        <template x-if="!folded">
          <.icon name="chevron_up" class="w-4 lg:w-5 h-3 lg:h-4 my-auto" />
        </template>
      </div>
      <div class="pl-6 pr-12 pb-6 select-text cursor-text xl:text-lg" x-show="!folded" x-transition>
        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end
end
