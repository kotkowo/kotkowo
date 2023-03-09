defmodule KotkowoWeb.Components.Notifiers do
  @moduledoc """
  Provides components that are meant to give action feedback to the user.
  """

  use KotkowoWeb, :verified_routes
  use Phoenix.Component

  import KotkowoWeb.Components.Icons

  attr :message, :string, required: true

  attr :event, :string,
    required: true,
    doc: "Global JS event to listen to. Use alpine $dispatch to trigger."

  attr :icon, :string, values: [nil | icons_all()], default: nil

  def toast(assigns) do
    ~H"""
    <span x-data class="hidden">
      <template x-teleport="#shadow-realm">
        <div
          x-data="toast"
          x-show="percentage > 0"
          x-cloak
          class={[
            "flex items-center fixed left-1/2 -translate-x-1/2 bottom-2",
            "bg-black text-white font-bold w-60 h-12 px-6 rounded-full select-none"
          ]}
          {%{"x-on:#{@event}.window" => "show"}}
        >
          <.icon :if={@icon != nil} name="clipboard_done" class="w-7 h-7" />
          <span class="mx-auto"><%= @message %></span>
          <div class="w-48 h-1 bottom-0 left-6 fixed flex">
            <span class="bg-primary-lighter h-full" x-bind:style="`width: ${percentage}%;`"></span>
          </div>
        </div>
      </template>
    </span>
    """
  end
end
