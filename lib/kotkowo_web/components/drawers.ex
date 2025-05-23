defmodule KotkowoWeb.Components.Drawers do
  @moduledoc """
  Provides card UI components.
  """

  use KotkowoWeb, :verified_routes
  use Phoenix.Component

  import KotkowoWeb.Components.Icons
  import KotkowoWeb.WebHelpers
  import Tails

  attr :title, :string, required: true
  attr :class, :string, default: ""
  attr :folded, :boolean, default: true
  attr :allow_unfolded, :boolean, default: false
  attr :class_when_hidden, :string, default: "hidden xl:block"
  attr :title_class, :string, default: "font-bold xl:text-xl"
  slot :inner_block, required: true, doc: "Content when unfolded"

  def drawer(assigns) do
    assigns = assign(assigns, :anchor, sanitize_to_anchor(assigns.title))

    ~H"""
    <div
      id={@anchor}
      x-data={"{isXl: $isBreakpoint('lg+') == true && #{@allow_unfolded}, folded: #{@folded} && !(window.location.hash === '##{@anchor}')}"}
      x-on:resize.window={"isXl = $isBreakpoint('lg+') == true && #{@allow_unfolded}"}
    >
      <template x-if="!isXl">
        <div class={
          classes([
            "border rounded-xl flex flex-col cursor-pointer select-none"
            # @class
          ])
        }>
          <div
            class="p-6 flex justify-between align-center"
            x-bind:class="!folded && 'pb-3'"
            x-on:click="folded = !folded"
          >
            <span class={@title_class}>{@title}</span>
            <template x-if="folded">
              <.icon name="chevron_down" class="w-4 xl:w-5 h-3 xl:h-4 my-auto" />
            </template>
            <template x-if="!folded">
              <.icon name="chevron_up" class="w-4 xl:w-5 h-3 xl:h-4 my-auto" />
            </template>
          </div>
          <div
            class="pl-6 pr-12 pb-6 select-text cursor-text xl:text-lg font-inter text-secondary"
            x-show="!folded"
            x-transition
          >
            {render_slot(@inner_block)}
          </div>
        </div>
      </template>
      <template x-if="isXl" class={classes([@class_when_hidden, "text-xl font-inter text-secondary"])}>
        {render_slot(@inner_block)}
      </template>
    </div>
    """
  end
end
