defmodule KotkowoWeb.Components.Modals do
  @moduledoc """
  Provides modal UI components.
  """
  use Phoenix.Component, global_prefixes: ~w(x-)

  import KotkowoWeb.Components.Icons
  import KotkowoWeb.Gettext

  attr :href, :string, required: true

  def share_modal(assigns) do
    ~H"""
    <div
      x-show="shown"
      class="flex flex-col gap-y-6 w-96 left-1/2 top-1/2 p-4 -translate-x-1/2 -translate-y-1/2 border-gray border rounded-2xl bg-white shadow-xl fixed z-20"
    >
      <div class="flex flex-row">
        <span class="font-bold text-2xl"><%= gettext("Udostępnij") %></span>
        <Heroicons.x_mark
          mini
          x-on:click="
        shown = !shown;
        console.log(shown);
        "
          class="ml-auto w-8"
        />
      </div>
      <div>
        <span><%= gettext("Udostępnij ten link przez") %>:</span>
        <div class="flex flex-row justify-evenly mt-2">
          <div class="border border-blue-800 rounded-full p-3">
            <.icon name="facebook" class="w-5 invert" />
          </div>
          <div class="border border-blue-800 rounded-full p-3 ">
            <.icon name="facebook" class="w-5 invert" />
          </div>
          <div class="border border-blue-800 rounded-full p-3 ">
            <.icon name="facebook" class="w-5 invert" />
          </div>
          <div class="border border-blue-800 rounded-full p-3 ">
            <.icon name="facebook" class="w-5 invert" />
          </div>
          <div class="border border-blue-800 rounded-full p-3 ">
            <.icon name="facebook" class="w-5 invert" />
          </div>
        </div>
      </div>

      <div class="flex flex-col gap-y-2" x-data={~c"{copied: false}"}>
        <span><%= gettext("Kliknij, aby skopiować link") %></span>
        <input
          x-on:click="
          navigator.clipboard.writeText($el.value);
          copied = true;
          "
          class="w-full cursor-pointer"
          type="url"
          value={@href}
          readonly
        />
        <span class="self-center" x-show="copied">Copied!</span>
      </div>
    </div>
    """
  end
end
