defmodule KotkowoWeb.Components.Modals do
  @moduledoc """
    Provides Modal UI components
  """
  use Phoenix.Component, global_prefixes: ~w(x-)

  import KotkowoWeb.Components.Icons
  import KotkowoWeb.Gettext

  def share_modal(assigns) do
    ~H"""
    <dialog
      id="share-dialog"
      class="opacity-100 fixed h-screen top-0 left-0 w-screen bg-blue-300/10 z-20 transition duration-150"
    >
      <div
        id="share-content"
        class="flex flex-col gap-y-4 sm:gap-y-6 w-72 sm:w-96 left-1/2 top-1/2 p-4 -translate-x-1/2 -translate-y-2/3 border-gray border rounded-2xl bg-white shadow-xl fixed z-20"
      >
        <span class="font-bold text-xl sm:text-2xl"><%= gettext("Udostępnij") %></span>

        <div>
          <span><%= gettext("Udostępnij ten link przez") %>:</span>
          <div class="flex flex-row justify-evenly mt-2">
            <a
              id="share-facebook"
              href="#"
              target="_blank"
              rel="noopener noreferrer"
              class="border border-blue-800 rounded-full sm:p-3 p-2"
            >
              <.icon name="facebook" class="sm:w-5 w-4 invert" />
            </a>
            <a
              id="share-twitter"
              href="#"
              target="_blank"
              rel="noopener noreferrer"
              class="border border-black rounded-full sm:p-3 p-2"
            >
              <.icon name="twitter" class="sm:w-5 w-4" />
            </a>
          </div>
        </div>

        <div class="flex flex-col gap-y-2" x-data={~c"{copied: false}"}>
          <span><%= gettext("Kliknij, aby skopiować link") %></span>
          <input
            id="share-copy"
            x-on:click="
          navigator.clipboard.writeText($el.value);
          copied = true;
          "
            class="w-full cursor-pointer rounded-3xl"
            type="url"
            value=""
            readonly
          />
          <span class="self-center" x-show="copied"><%= gettext("Skopiowane!") %></span>
        </div>
      </div>
    </dialog>
    """
  end
end
