defmodule KotkowoWeb.Components.Breadcrumb do
  @moduledoc false
  use KotkowoWeb, :component

  slot :crumb do
    attr :navigate, :string
    attr :active, :boolean
    attr :disabled, :boolean
  end

  def breadcrumb(assigns) do
    ~H"""
    <div class="gap-x-2 text-sm pb-8 pt-10 items-center hidden xl:flex">
      <div>
        <.link navigate={~p"/"}>
          Strona główna
        </.link>
      </div>
      <div :for={crumb <- @crumb} class="flex gap-x-2 items-center">
        <span class="mb-0.5">&gt;</span>
        <.link navigate={crumb[:navigate]} class={[crumb[:active] && "font-bold pointer-events-none", crumb[:disabled] && "pointer-events-none"]}>
          <%= render_slot(crumb) %>
        </.link>
      </div>
    </div>
    """
  end
end
