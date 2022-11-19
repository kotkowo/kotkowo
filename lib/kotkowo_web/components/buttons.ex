defmodule KotkowoWeb.Components.Buttons do
  @moduledoc """
  Provides button UI components.
  """

  use Phoenix.Component

  attr :href, :string, required: true, doc: "Button's link"
  attr :type, :string, values: ~w(primary outline), default: "primary", doc: "Button's type"

  attr :class, :string, default: ""
  attr :rest, :global

  slot :inner_block, required: true, doc: "Button's content"

  def button(assigns) do
    ~H"""
    <a
      href="#"
      class={[
        @type == "primary" && "bg-primary text-white hover:text-white hover:bg-primary-lighter",
        @type == "outline" &&
          "border-2 border-primary text-primary hover:text-primary-lighter hover:border-primary-lighter box-border",
        "rounded-full py-3 px-10 text-center text-lg font-medium",
        "w-max transition-colors ease-in-out duration-150",
        @class
      ]}
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </a>
    """
  end
end
