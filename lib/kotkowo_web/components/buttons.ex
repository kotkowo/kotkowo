defmodule KotkowoWeb.Components.Buttons do
  @moduledoc """
  Provides button UI components.
  """

  use Phoenix.Component, global_prefixes: ~w(x-)

  import Tails

  attr :prefix, :string, required: true, examples: ["PESEL: "]
  attr :text_to_copy, :string, required: true
  attr :class, :string, default: ""
  attr :prefix_class, :string, default: ""

  def click_to_copy(assigns) do
    ~H"""
    <div
      x-data={"{to_copy: '#{@text_to_copy}'}"}
      class={
        classes([
          "flex flex-row space-x-2 border-none w-fit",
          @class
        ])
      }
      x-on:click="navigator.clipboard.writeText(to_copy); $dispatch('toast', {message: 'Skopiowane', icon: '📋'})"
      value={@text_to_copy}
    >
      <span :if={@prefix != ""} class={@prefix_class}><%= @prefix %></span><span class="cursor-pointer hover:text-primary-lighter transition"><%= @text_to_copy %></span>
    </div>
    """
  end

  attr :type, :string,
    values: ~w(primary secondary outline),
    default: "primary",
    doc: "Button's type"

  attr :class, :string, default: ""
  attr :share_href, :string, required: false
  attr :share_quote, :string, required: false
  attr :rest, :global, include: ~w(href navigate)

  slot :inner_block, required: true, doc: "Button's content"

  def button(assigns) do
    ~H"""
    <.link
      class={[
        @type == "primary" &&
          "py-3 bg-primary text-white hover:text-white hover:bg-primary-lighter px-6 xl:px-10",
        @type == "secondary" &&
          "py-3 bg-white text-primary hover:bg-primary-lighter px-6",
        @type == "outline" &&
          "border-2 border-primary text-primary hover:text-primary-lighter hover:border-primary-lighter box-border px-6 xl:px-10 py-2 xl:py-2.5",
        "rounded-full text-center xl:text-lg font-medium select-none",
        "w-max transition-colors ease-in-out duration-150",
        @class
      ]}
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </.link>
    """
  end

  attr :id, :string, required: true
  attr :name, :string, required: true
  attr :label, :string, required: true
  attr :options, :list, required: true
  attr :value, :list, required: true
  attr :errors, :list, default: []
  attr :required, :boolean, default: false
  attr :rest, :global

  def checkgroup(assigns) do
    assigns = assign(assigns, :name, assigns.name <> "[]")

    ~H"""
    <div class="flex flex-col space-y-4">
      <h3 class="font-bold text-primary text-sm"><%= @label %></h3>
      <input type="hidden" name={@name} value="" />
      <div class="flex flex-col space-y-6 lowercase">
        <div :for={{label, value} <- @options}>
          <label class="text-sm" for={"#{@name}-#{value}"}>
            <input
              type="checkbox"
              id={"#{@id}-#{value}"}
              name={@name}
              value={value}
              checked={value in @value}
              class="mr-3.5 border-gray rounded"
              {@rest}
            />
            <%= label %>
          </label>
        </div>
      </div>
    </div>
    """
  end
end
