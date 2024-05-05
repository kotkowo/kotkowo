defmodule KotkowoWeb.Components.Modals do
  @moduledoc """
  Provides modal UI components.
  """
  use Phoenix.Component, global_prefixes: ~w(x-)

  import KotkowoWeb.Components.Icons
  import KotkowoWeb.Gettext

  attr :href, :string, required: true
  attr :quote, :string, default: ""

  def share_modal(assigns) do
    ~H"""
    <div
      x-show="shown"
      x-transition:enter="transition ease-out duration-150"
      x-transition:enter-start="opacity-0"
      x-transition:enter-end="opacity-100"
      x-transition:leave="transition ease-in duration-150"
      x-transition:leave-start="opacity-100"
      x-transition:leave-end="opacity-0"
      class="flex flex-col gap-y-4 sm:gap-y-6 w-72 sm:w-96 left-1/2 top-1/2 p-4 -translate-x-1/2 -translate-y-1/2 border-gray border rounded-2xl bg-white shadow-xl fixed z-20"
    >
      <div class="flex flex-row">
        <span class="font-bold text-xl sm:text-2xl"><%= gettext("Udostępnij") %></span>
        <Heroicons.x_mark mini x-on:click="
        shown = !shown;
        " class="ml-auto w-8" />
      </div>
      <div>
        <span><%= gettext("Udostępnij ten link przez") %>:</span>
        <div class="flex flex-row justify-evenly mt-2">
          <a
            href={"https://www.facebook.com/sharer/sharer.php?u=#{@href}&hashtag=kotkowo"}
            target="_blank"
            rel="noopener noreferrer"
            class="border border-blue-800 rounded-full sm:p-3 p-2"
          >
            <.icon name="facebook" class="sm:w-5 w-4 invert" />
          </a>
          <a
            href={"https://twitter.com/intent/tweet?url=#{@href}&text=#{@quote}"}
            target="_blank"
            rel="noopener noreferrer"
            class="border border-blue-800 rounded-full sm:p-3 p-2"
          >
            <.icon name="twitter" class="sm:w-5 w-4" />
          </a>
        </div>
      </div>

      <div class="flex flex-col gap-y-2" x-data={~c"{copied: false}"}>
        <span><%= gettext("Kliknij, aby skopiować link") %></span>
        <input
          x-on:click="
          navigator.clipboard.writeText($el.value);
          copied = true;
          "
          class="w-full cursor-pointer rounded-3xl"
          type="url"
          value={@href}
          readonly
        />
        <span class="self-center" x-show="copied"><%= gettext("Skopiowane!") %></span>
      </div>
    </div>
    """
  end
end
