defmodule KotkowoWeb.Components.Drawers do
  @moduledoc """
  Provides card UI components.
  """

  use KotkowoWeb, :verified_routes
  use Phoenix.Component

  import KotkowoWeb.Components.Icons
  import Tails

  attr :title, :string, required: true
  attr :class, :string, default: ""
  attr :folded, :boolean, default: true
  attr :class_when_hidden, :string, default: "hidden xl:block"
  attr :title_class, :string, default: "font-bold xl:text-xl"
  slot :inner_block, required: true, doc: "Content when unfolded"

  def drawer(assigns) do
    ~H"""
    <div
      x-data={"{isXl: window.innerWidth >= 1280, folded: #{@folded}}"}
      x-on:resize.window="isXl = window.innerWidth >= 1280"
    >
      <template x-if="!isXl">
        <div class={
          classes([
            "border rounded-xl xl:w-[757px] flex flex-col cursor-pointer select-none",
            @class
          ])
        }>
          <div
            class="p-6 flex justify-between align-center"
            x-bind:class="!folded && 'pb-3'"
            x-on:click="folded = !folded"
          >
            <span class={@title_class}><%= @title %></span>
            <template x-if="folded">
              <.icon name="chevron_down" class="w-4 xl:w-5 h-3 xl:h-4 my-auto" />
            </template>
            <template x-if="!folded">
              <.icon name="chevron_up" class="w-4 xl:w-5 h-3 xl:h-4 my-auto" />
            </template>
          </div>
          <div
            class="pl-6 pr-12 pb-6 select-text cursor-text xl:text-lg"
            x-show="!folded"
            x-transition
          >
            <%= render_slot(@inner_block) %>
          </div>
        </div>
      </template>
      <template x-if="isXl" class={@class_when_hidden}>
        <%= render_slot(@inner_block) %>
      </template>
    </div>
    """
  end
end
