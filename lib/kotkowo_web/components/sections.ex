defmodule KotkowoWeb.Components.Sections do
  @moduledoc """
  Provides sections UI components.
  """
  use Phoenix.Component

  @type nested_link :: {String.t(), String.t()}
  @type css_classes :: [String.t()]
  @type link :: {String.t(), String.t() | nil, [nested_link()], css_classes()}

  @doc """
  Renders a header with title.
  """
  attr :contact_email, :string,
    required: true,
    examples: ["kotkowo@email.com"],
    doc: "Organization's contact email"

  attr :links, :list,
    required: true,
    examples: [
      [
        {"Aktualności", nil,
         [
           {"Z ostatniej chwili", "#"},
           {"Znalazły dom", "#"}
         ], []},
        {"Zaginione/znalezione", "#zaginione-znalezione", [], []},
        {"Jak pomóc", nil,
         [
           {"Przekaż nam 1% podatku", "#"}
         ], ["p-2", "bg-highlight"]}
      ]
    ],
    doc: "A list of links with type t:link/0"

  slot :inner_block, required: true, doc: "Header title"

  def header(assigns) do
    ~H"""
    <header class="flex flex-col" x-data="{expanded: false}">
      <div class="px-10 gap-x-10 h-12 bg-primary text-white flex flex-row-reverse w-full hidden xl:flex">
        <div class="my-auto">
          <a href="#">
            <img
              class="invert"
              src="data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij48cGF0aCBkPSJNMTIgMGMtNi42MjcgMC0xMiA1LjM3My0xMiAxMnM1LjM3MyAxMiAxMiAxMiAxMi01LjM3MyAxMi0xMi01LjM3My0xMi0xMi0xMnptMyA4aC0xLjM1Yy0uNTM4IDAtLjY1LjIyMS0uNjUuNzc4djEuMjIyaDJsLS4yMDkgMmgtMS43OTF2N2gtM3YtN2gtMnYtMmgydi0yLjMwOGMwLTEuNzY5LjkzMS0yLjY5MiAzLjAyOS0yLjY5MmgxLjk3MXYzeiIvPjwvc3ZnPg=="
            />
          </a>
        </div>
        <div class="my-auto">
          <a href={"mailto:#{@contact_email}"} class="hover:text-black">
            <Heroicons.envelope class="mb-0.5 w-5 h-5 inline" />
            <span class="underline"><%= @contact_email %></span>
          </a>
        </div>
      </div>

      <div
        class="px-10 flex flex-col row w-full items-center xl:border-b-2 border-primary p-2"
        x-bind:class="expanded || 'border-b-2'"
      >
        <div class="h-full flex flex-col xl:flex-row items-center gap-x-10 w-full xl:w-auto">
          <div class="flex flex-row items-center w-full xl:w-auto pt-2 xl:pt-0 self-start xl:self-auto">
            <img src="https://via.placeholder.com/32" alt="logo" />
            <span class="ml-4 font-bold text-primary xl:text-black">
              <%= render_slot(@inner_block) %>
            </span>
            <Heroicons.bars_3
              class="text-primary cursor-pointer ml-auto w-8 h-8 inline xl:hidden"
              @click="expanded = !expanded"
            />
          </div>

          <div
            class="flex flex-col gap-y-2 pt-4 text-primary xl:text-black xl:flex xl:pt-0 xl:gap-y-0 xl:gap-x-10 xl:flex-row xl:items-center w-full"
            x-bind:class="expanded || 'hidden'"
            x-cloak
          >
            <%= for {title, href, nested_links, text_classes} <- @links do %>
              <div x-data="{expanded: false}" class="mx-4 xl:mx-0">
                <a
                  @click="expanded = !expanded"
                  @click.outside="expanded = false"
                  class="static cursor-pointer py-4 border-b-2 border-primary xl:font-normal flex xl:block flex-row w-full xl:w-auto items-center justify-between xl:py-0 xl:border-none"
                  x-bind:class="!expanded || 'font-bold'"
                  href={href}
                >
                  <span class={text_classes}><%= title %></span>

                  <%= if nested_links != [] do %>
                    <Heroicons.chevron_down class="w-5 h-5 inline xl:hidden" x-show="!expanded" />
                    <Heroicons.chevron_up class="w-5 h-5 inline xl:hidden" x-show="expanded" />
                  <% end %>

                  <%= if nested_links != [] do %>
                    <div
                      class="absolute z-50 py-5 bg-white rounded-2xl border flex flex-col drop-shadow-md hidden xl:flex"
                      x-show="expanded"
                    >
                      <%= for {title, href} <- nested_links do %>
                        <a href={href} class="py-3 px-5 hover:bg-primary-light hover:text-primary">
                          <%= title %>
                        </a>
                      <% end %>
                    </div>
                  <% end %>
                </a>
                <%= if nested_links != [] do %>
                  <ul
                    x-show="expanded"
                    class="space-y-4 mt-4 xl:hidden pb-4 border-b-2 border-primary"
                  >
                    <%= for {title, href} <- nested_links do %>
                      <li><a href={href}><%= title %></a></li>
                    <% end %>
                  </ul>
                <% end %>
              </div>
            <% end %>

            <div class="mt-5 border-b-2 border-primary pb-6 xl:hidden">
              <div class="text-black flex flex-col space-y-3 mx-4">
                <h4>Kontakt:</h4>
                <a href={"mailto:#{@contact_email}"}>
                  <Heroicons.envelope class="mb-0.5 w-5 h-5 inline" />
                  <%= @contact_email %>
                </a>
                <div class="flex space-x-6">
                  <a href="#">
                    <img
                      class="w-10 h-10"
                      src="data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij48cGF0aCBkPSJNMTIgMGMtNi42MjcgMC0xMiA1LjM3My0xMiAxMnM1LjM3MyAxMiAxMiAxMiAxMi01LjM3MyAxMi0xMi01LjM3My0xMi0xMi0xMnptMyA4aC0xLjM1Yy0uNTM4IDAtLjY1LjIyMS0uNjUuNzc4djEuMjIyaDJsLS4yMDkgMmgtMS43OTF2N2gtM3YtN2gtMnYtMmgydi0yLjMwOGMwLTEuNzY5LjkzMS0yLjY5MiAzLjAyOS0yLjY5MmgxLjk3MXYzeiIvPjwvc3ZnPg=="
                    />
                  </a>
                  <a href="#">
                    <img
                      class="w-10 h-10"
                      src="data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMjQiIGhlaWdodD0iMjQiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgZmlsbC1ydWxlPSJldmVub2RkIiBjbGlwLXJ1bGU9ImV2ZW5vZGQiPjxwYXRoIGQ9Ik0xMiAwYy02LjYyNyAwLTEyIDQuOTc1LTEyIDExLjExMSAwIDMuNDk3IDEuNzQ1IDYuNjE2IDQuNDcyIDguNjUydjQuMjM3bDQuMDg2LTIuMjQyYzEuMDkuMzAxIDIuMjQ2LjQ2NCAzLjQ0Mi40NjQgNi42MjcgMCAxMi00Ljk3NCAxMi0xMS4xMTEgMC02LjEzNi01LjM3My0xMS4xMTEtMTItMTEuMTExem0xLjE5MyAxNC45NjNsLTMuMDU2LTMuMjU5LTUuOTYzIDMuMjU5IDYuNTU5LTYuOTYzIDMuMTMgMy4yNTkgNS44ODktMy4yNTktNi41NTkgNi45NjN6Ii8+PC9zdmc+"
                    />
                  </a>
                </div>
              </div>
            </div>

            <input
              placeholder="Szukaj..."
              class="w-48 px-3 py-1 inline border-2 rounded-full hidden xl:block"
            />
          </div>
        </div>
      </div>
    </header>
    """
  end
end
