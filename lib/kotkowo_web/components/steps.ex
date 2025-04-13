defmodule KotkowoWeb.Components.Steps do
  @moduledoc """
  Provides steps UI components.
  """

  use Phoenix.Component

  attr :class, :string, default: ""

  slot :inner_block, required: false
  slot :actions, required: false

  def step(assigns) do
    ~H"""
    <div class={[
      "mx-auto flex rounded-full bg-primary-lighter w-16 xl:w-24 h-16 xl:h-24 xl:row-start-1"
    ]}>
      <span class="m-auto font-manrope text-2xl xl:text-4xl text-white counter-increment after:counter-result">
      </span>
    </div>
    <span
      :if={@inner_block != []}
      class="xl:row-start-2 text-center xl:text-lg px-6 xl:px-0 tracking-wider lg:tracking-normal"
    >
      {render_slot(@inner_block)}
    </span>
    <span :if={@actions != []} class="xl:row-start-3 mx-auto">{render_slot(@actions)}</span>
    """
  end

  attr :class, :string, default: nil

  slot :inner_block, required: true

  def steps(assigns) do
    ~H"""
    <div class={["grid xl:grid-flow-col auto-cols-fr gap-x-4 gap-y-10 counter-reset", @class]}>
      {render_slot(@inner_block)}
    </div>
    """
  end
end
