defmodule KotkowoWeb.Components.Buttons do
  @moduledoc """
  Provides button UI components.
  """

  use Phoenix.Component

  attr :href, :string, required: true, doc: "Button's link"

  attr :type, :string,
    values: ~w(primary secondary outline),
    default: "primary",
    doc: "Button's type"

  attr :class, :string, default: ""
  attr :rest, :global

  slot :inner_block, required: true, doc: "Button's content"

  def button(assigns) do
    ~H"""
    <a
      href={@href}
      class={[
        @type == "primary" &&
          "py-3 bg-primary text-white hover:text-white hover:bg-primary-lighter px-6 xl:px-10",
        @type == "secondary" &&
          "py-3 bg-white text-primary hover:bg-primary-lighter px-6",
        @type == "outline" &&
          "border-2 border-primary text-primary hover:text-primary-lighter hover:border-primary-lighter box-border px-6 xl:px-10 py-2 xl:py-2.5",
        "rounded-full text-center xl:text-lg font-medium",
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
