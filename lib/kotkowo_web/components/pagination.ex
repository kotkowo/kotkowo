defmodule KotkowoWeb.Components.Pagination do
  @moduledoc false
  use KotkowoWeb, :component

  import KotkowoWeb.Components.Icons

  attr :first_page, :integer, default: 1
  attr :default_limit, :integer, default: 30
  attr :selected_page, :integer, required: true
  attr :last_page, :integer, required: true
  attr :callback, :string, default: "select_page", required: false

  def pagination_bar(assigns) do
    assigns =
      assigns
      |> assign(:previous_page, assigns.selected_page - 1)
      |> assign(:next_page, assigns.selected_page + 1)

    ~H"""
    <div class="flex flex-row text-xl gap-x-4 text-lg">
      <button
        :if={@selected_page != @first_page}
        phx-click={@callback}
        class="p-4"
        value={@selected_page - 1}
      >
        <.icon class=" rotate-90 brightness-0 hover:brightness-100 transition" name="chevron_down" />
      </button>

      <div class="self-center gap-4 hidden lg:inline">
        <button
          :if={@selected_page > 2}
          class="w-14 h-14 transition hover:text-primary"
          phx-click={@callback}
          value={@first_page}
        >
          <%= @first_page %>
        </button>
        <span :if={@selected_page > 2} class="w-14 h-14">...</span>
        <button
          :if={@selected_page != @first_page}
          class="w-14 h-14 transition hover:text-primary"
          phx-click={@callback}
          value={@previous_page}
        >
          <%= @previous_page %>
        </button>
        <button class="font-bold w-14 h-14">
          <%= @selected_page %>
        </button>
        <button
          :if={@selected_page != @last_page}
          class="w-14 h-14 transition hover:text-primary"
          phx-click={@callback}
          value={@next_page}
        >
          <%= @next_page %>
        </button>
        <span :if={@selected_page < @last_page - 1} class="w-14 h-14">...</span>

        <button
          :if={@selected_page < @last_page - 1}
          class="w-14 h-14 transition hover:text-primary"
          phx-click={@callback}
          value={@last_page}
        >
          <%= @last_page %>
        </button>
      </div>
      <div class="self-center flex flex-row lg:hidden gap-4">
        <span><%= @selected_page %></span>
        <span>z</span>
        <span><%= @last_page %></span>
      </div>

      <button
        :if={@selected_page != @last_page}
        class="p-4"
        phx-click={@callback}
        value={@selected_page + 1}
      >
        <.icon class="rotate-90 brightness-0 hover:brightness-100 transition" name="chevron_up" />
      </button>
    </div>
    """
  end
end
