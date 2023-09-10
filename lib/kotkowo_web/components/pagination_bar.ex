defmodule KotkowoWeb.Components.PaginationBar do
  @moduledoc false

  use Phoenix.Component

  attr(:selected_page, :integer, required: true)
  attr(:last_page, :integer, required: true)

  def pagination_bar(assigns) do
    assigns =
      assigns
      |> assign(:previous_page, assigns.selected_page - 1)
      |> assign(:next_page, assigns.selected_page + 1)

    ~H"""
    <div class="flex flex-row text-xl gap-x-4 text-lg">
      <button :if={@selected_page != 1} phx-click="select_page" class="p-4" value={@selected_page - 1}>
        <img class="-scale-100" src="/images/arrow_right.svg" />
      </button>
      <img :if={@selected_page == 1} class="p-4" src="/images/arrow_left.svg" />
      <div class="self-center gap-4 hidden lg:inline">
        <button :if={@selected_page > 2} class="w-14 h-14" phx-click="select_page" value={1}>
          1
        </button>
        <text :if={@selected_page > 2} class="w-14 h-14">...</text>
        <button
          :if={@selected_page != 1}
          class="w-14 h-14"
          phx-click="select_page"
          value={@previous_page}
        >
          <%= @previous_page %>
        </button>
        <button class="font-bold w-14 h-14">
          <%= @selected_page %>
        </button>
        <button
          :if={@selected_page != @last_page}
          class="w-14 h-14"
          phx-click="select_page"
          value={@next_page}
        >
          <%= @next_page %>
        </button>
        <text :if={@selected_page < @last_page - 1} class="w-14 h-14">...</text>

        <button
          :if={@selected_page < @last_page - 1}
          class="w-14 h-14"
          phx-click="select_page"
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
      <img :if={@selected_page == @last_page} class="-scale-100 p-4" src="/images/arrow_left.svg" />

      <button
        :if={@selected_page != @last_page}
        class="p-4"
        phx-click="select_page"
        value={@selected_page + 1}
      >
        <img src="/images/arrow_right.svg" />
      </button>
    </div>
    """
  end
end
