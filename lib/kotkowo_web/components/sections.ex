defmodule KotkowoWeb.Components.Sections do
  @moduledoc """
  Provides sections UI components.
  """

  use KotkowoWeb, :verified_routes
  use Phoenix.Component, global_prefixes: ~w(x-)
  use Gettext, backend: KotkowoWeb.Gettext

  import KotkowoWeb.Components.Buttons
  import KotkowoWeb.Components.Icons
  import KotkowoWeb.Constants
  import Tails

  @type nested_link :: {String.t(), String.t()}
  @type css_classes :: [String.t()]
  @type link :: {String.t(), String.t() | nil, [nested_link()], css_classes()}

  @doc """
  Renders a header with title.
  """
  attr :contact_email, :string,
    required: true,
    examples: ["fundacja.kotkowo@gmail.com"],
    doc: "Organization's contact email"

  attr :links, :list,
    required: true,
    examples: [
      [
        {"Aktualności", nil,
         [
           {"Z ostatniej chwili", "/aktualnosci/z-ostatniej-chwili"},
           {"Znalazły dom", "/aktualnosci/znalazly-dom"}
         ], []},
        {"Zaginione/znalezione", "/zaginione-znalezione", [], []},
        {"Jak pomóc", nil,
         [
           {"Przekaż nam 1,5% podatku", "/przekaz-nam-podatek"}
         ], ["p-2", "bg-highlight"]}
      ]
    ],
    doc: "A list of links with type t:link/0"

  slot(:inner_block, required: true, doc: "Header title")

  def header(assigns) do
    ~H"""
    <header class="flex flex-col" x-data="{expanded: false}">
      <div class="px-10 gap-x-10 h-12 bg-primary text-white flex flex-row-reverse w-full hidden xl:flex">
        <div class="my-auto">
          <a href={kotkowo_facebook()} target="_blank" rel="noopener noreferrer">
            <.icon name="facebook" class="w-7" />
          </a>
        </div>
        <div class="my-auto">
          <a href={"mailto:#{@contact_email}"} class="hover:text-white">
            <.icon name="envelope" class="mb-0.5 w-4 inline" />
            <span class="underline font-bold">{@contact_email}</span>
          </a>
        </div>
      </div>

      <div
        class="px-10 flex flex-col row w-full items-center xl:border-b-2 border-primary p-2 pb-3 xl:pb-2"
        x-bind:class="expanded || 'border-b-2'"
      >
        <div class="h-full flex flex-col xl:flex-row items-center gap-x-10 w-full xl:w-auto">
          <div class="flex flex-row items-center w-full xl:w-auto pt-2 xl:pt-0 self-start xl:self-auto">
            <img class="w-10 h-10" src={~p"/images/kotkowo_logo_black.svg"} alt="logo" />
            <.link
              class="ml-4 xl:font-manrope font-bold text-primary text-lg xl:text-2xl xl:text-black xl:mr-12"
              navigate={~p"/"}
            >
              {render_slot(@inner_block)}
            </.link>
            <.icon
              name="bars"
              class="text-primary cursor-pointer ml-auto w-8 h-8 inline xl:hidden"
              x-on:click="expanded = !expanded"
            />
          </div>

          <div
            class="flex flex-col gap-y-2 pt-4 text-primary xl:text-black xl:flex xl:pt-0 xl:gap-y-0 xl:gap-x-10 xl:flex-row xl:items-center w-full"
            x-bind:class="expanded || 'hidden'"
            x-cloak
          >
            <%= for {title, href, nested_links, text_classes} <- @links do %>
              <div
                x-data="{expanded: false}"
                class="mx-4 xl:mx-0"
                x-on:mouseover="if($isBreakpoint('lg+')) expanded = true"
                x-on:mouseleave="if($isBreakpoint('lg+')) expanded = false"
                x-on:click="if($isBreakpoint('lg-')) expanded = !expanded"
              >
                <div class={[
                  "text-lg static cursor-pointer py-4 border-b-2 border-primary",
                  "flex xl:block flex-row w-full xl:w-auto items-center justify-between xl:py-0 xl:border-none"
                ]}>
                  <.link navigate={href} class={text_classes}>{title}</.link>

                  <%= if nested_links != [] do %>
                    <.icon name="chevron_down" class="w-5 inline xl:hidden" x-show="!expanded" />
                    <.icon name="chevron_up" class="w-5 inline xl:hidden" x-show="expanded" />
                  <% end %>
                  <div
                    :if={nested_links != []}
                    class="absolute z-50 py-5 bg-white rounded-2xl border flex flex-col drop-shadow-md hidden xl:flex"
                    x-show="expanded"
                  >
                    <%= for {title, href} <- nested_links do %>
                      <.link
                        navigate={href}
                        class="py-3 px-5 text-lg hover:bg-primary-light hover:text-primary"
                      >
                        {title}
                      </.link>
                    <% end %>
                  </div>
                </div>
                <ul
                  :if={nested_links != []}
                  x-show="expanded"
                  class="space-y-4 mt-4 xl:hidden pb-4 border-b-2 border-primary"
                >
                  <%= for {title, href} <- nested_links do %>
                    <li><.link navigate={href}>{title}</.link></li>
                  <% end %>
                </ul>
              </div>
            <% end %>

            <div class="mt-5 border-b-2 border-primary pb-6 xl:hidden">
              <div class="text-black flex flex-col space-y-4 mx-4">
                <h4 class="text-lg">{gettext("Kontakt:")}</h4>
                <a href={"mailto:#{@contact_email}"} class="hover:text-black">
                  <.icon name="envelope" class="mb-0.5 w-5 h-5 inline invert" />
                  {@contact_email}
                </a>
                <div class="flex space-x-6">
                  <a href={kotkowo_facebook()} target="_blank" rel="noopener noreferrer">
                    <.icon name="facebook" class="w-10 invert" />
                  </a>
                  <a href={kotkowo_messenger()} target="_blank" rel="noopener noreferrer">
                    <.icon name="messenger_black" class="w-10 h-10" />
                  </a>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </header>
    """
  end

  @doc """
  Renders a section
  """

  attr :class, :any, default: nil
  attr :parent_class, :any, default: nil
  attr :rest, :global

  slot(:inner_block, required: true, doc: "Inner content")

  def section(assigns) do
    ~H"""
    <div class={classes(["w-full even:bg-primary-light first:pt-0 py-10 xl:py-16", @parent_class])}>
      <section class={classes(["mx-auto max-w-3xl md:max-w-5xl lg:max-w-7xl", @class])} {@rest}>
        {render_slot(@inner_block)}
      </section>
    </div>
    """
  end

  attr :class, :string, default: nil
  attr :rest, :global

  def footer(assigns) do
    ~H"""
    <div class="w-full bg-primary text-white py-16">
      <footer
        class={["mx-auto max-w-3xl md:max-w-5xl lg:max-w-7xl overflow-x-hidden", @class]}
        {@rest}
      >
        <div class="grid auto-rows-auto xl:auto-cols-auto grid-flow-row xl:grid-flow-col xl:w-full xl:text-lg ml-6 gap-10">
          <.footer_section>
            <div class="flex space-x-6">
              <img src={~p"/images/kotkowo_logo.svg"} class="w-20 h-20" alt="logo" />
              <img src={~p"/images/oop_logo.svg"} class="w-20 h-20" alt="logo" />
            </div>

            <h3 class="text-xl xl:text-2xl font-bold font-manrope">Fundacja kotkowo</h3>

            <.footer_link href={"mailto:#{kotkowo_mail()}"} class="flex">
              <.icon name="envelope2" class="w-5 h-5 inline my-auto mr-2" />
              <span class="my-auto">{kotkowo_mail()}</span>
            </.footer_link>

            <div class="flex">
              <.icon name="city_scraper" class="w-5 h-5 inline mr-2" />
              <div class="flex flex-col space-y-2">
                <span>Adres biura</span>
                <.click_to_copy text_to_copy={"#{kotkowo_address()}\\n#{postal_code()}"}>
                  <span>{kotkowo_address()}</span>
                  <span>{postal_code()}</span>
                </.click_to_copy>
              </div>
            </div>

            <div class="flex space-x-6">
              <.link href={kotkowo_facebook()} target="_blank" rel="noopener noreferrer">
                <.icon name="facebook" class="w-8 h-8 inline" />
              </.link>
              <.link href={kotkowo_messenger()} target="_blank" rel="noopener noreferrer">
                <.icon name="messenger" class="w-8 h-8 inline" />
              </.link>
            </div>
          </.footer_section>

          <.footer_section title="Mapa strony">
            <.footer_link navigate={~p"/aktualnosci"}>Aktualności</.footer_link>
            <.footer_link navigate={~p"/adopcja/szukaja-domu"}>Adopcja</.footer_link>
            <.footer_link navigate={~p"/pomoc"}>Jak pomóc?</.footer_link>
            <.footer_link navigate={~p"/porady"}>Porady</.footer_link>
            <.footer_link navigate={~p"/o-nas/o-fundacji"}>O fundacji</.footer_link>
            <.footer_link navigate={~p"/zaginione-znalezione"}>Znalezione koty</.footer_link>
            <.footer_link navigate={~p"/o-nas/dokumenty"}>Kontakt</.footer_link>
          </.footer_section>

          <.footer_section title="Dokumenty">
            <.footer_link target="_blank" rel="noopener noreferrer" href={privacy_policy()}>
              Polityka prywatności
            </.footer_link>
            <.footer_link target="_blank" rel="noopener noreferrer" href={rodo_policy()}>
              RODO
            </.footer_link>
            <.footer_link
              :if={cookie_policy() != "#"}
              target="_blank"
              rel="noopener noreferrer"
              href={cookie_policy()}
            >
              Polityka cookies
            </.footer_link>
            <.footer_link target="_blank" rel="noopener noreferrer" href={adoption_form()}>
              Formularz adopcyjny
            </.footer_link>
            <.footer_link target="_blank" rel="noopener noreferrer" href={adoption_agreement()}>
              Umowa adopcyjna
            </.footer_link>
            <.footer_link navigate={~p"/o-nas/faq"}>
              FAQ
            </.footer_link>
          </.footer_section>

          <.footer_section title="Dane fundacji">
            <dl class="grid grid-flow-row auto-rows-auto gap-4">
              <.footer_definition term="KRS" description={krs()} />
              <.footer_definition term="NIP" description={nip()} />
              <.footer_definition term="REGON" description={regon()} />
              <.footer_definition term="Bank" description={bank()} />
              <.footer_definition term="Numer konta" description={bank_account_number()} />
              <.footer_definition term="SWIFT/BIC" description={swift_bic()} />
              <.footer_definition term="IBAN" description={iban()} />
            </dl>

            <.button navigate={~p"/pomoc/wsparcie-finansowe"} type="secondary" class="!mt-8">
              Wesprzyj kotki
            </.button>
          </.footer_section>
        </div>
      </footer>
    </div>
    """
  end

  attr :class, :string, default: nil
  attr :rest, :global, include: ~w(href navigate)
  slot(:inner_block, required: true)

  defp footer_link(assigns) do
    ~H"""
    <.link class={["hover:text-primary-lighter transition", @class]} {@rest}>
      {render_slot(@inner_block)}
    </.link>
    """
  end

  attr :title, :string, default: nil
  slot(:inner_block, required: true)

  defp footer_section(assigns) do
    ~H"""
    <section class="flex">
      <div class="flex flex-col space-y-4 xl:mx-auto">
        <h3 :if={@title != nil} class="text-xl xl:text-2xl font-bold font-manrope">{@title}</h3>
        {render_slot(@inner_block)}
      </div>
    </section>
    """
  end

  attr :term, :string, required: true
  attr :description, :string, required: true

  defp footer_definition(assigns) do
    ~H"""
    <div class="xl:grid grid-flow-col auto-cols-max gap-3">
      <dt class="font-bold">{@term}</dt>
      <.click_to_copy text_to_copy={@description}>
        <dd>{@description}</dd>
      </.click_to_copy>
    </div>
    """
  end

  attr :title, :string, required: true

  slot(:inner_block, required: true)

  def text_article(assigns) do
    ~H"""
    <article class="flex flex-col space-y-3">
      <h4 class="text-base xl:text-lg text-primary font-bold">{@title}</h4>
      <p class="text-sm xl:text-lg">{render_slot(@inner_block)}</p>
    </article>
    """
  end
end
