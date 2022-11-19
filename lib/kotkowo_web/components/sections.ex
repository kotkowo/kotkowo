defmodule KotkowoWeb.Components.Sections do
  @moduledoc """
  Provides sections UI components.
  """
  use Phoenix.Component

  import KotkowoWeb.Components.Icons

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
            <.icon_facebook class="w-7" />
          </a>
        </div>
        <div class="my-auto">
          <a href={"mailto:#{@contact_email}"} class="hover:text-white">
            <.icon_envelope class="mb-0.5 w-4 inline" />
            <span class="underline font-bold"><%= @contact_email %></span>
          </a>
        </div>
      </div>

      <div
        class="px-10 flex flex-col row w-full items-center xl:border-b-2 border-primary p-2 pb-3 xl:pb-2"
        x-bind:class="expanded || 'border-b-2'"
      >
        <div class="h-full flex flex-col xl:flex-row items-center gap-x-10 w-full xl:w-auto">
          <div class="flex flex-row items-center w-full xl:w-auto pt-2 xl:pt-0 self-start xl:self-auto">
            <img src="https://via.placeholder.com/32" alt="logo" />
            <span class="ml-4 xl:font-manrope font-bold text-primary text-xl xl:text-black xl:mr-12">
              <%= render_slot(@inner_block) %>
            </span>
            <.icon_bars
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
                <a href={"mailto:#{@contact_email}"} class="hover:text-black">
                  <.icon_envelope class="mb-0.5 w-5 h-5 inline invert" />
                  <%= @contact_email %>
                </a>
                <div class="flex space-x-6">
                  <a href="#">
                    <.icon_facebook class="w-10 invert" />
                  </a>
                  <a href="#">
                    <.icon_messenger class="w-10" />
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
