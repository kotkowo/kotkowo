defmodule KotkowoWeb.Components.Cards do
  @moduledoc """
  Provides card UI components.
  """

  use KotkowoWeb, :verified_routes
  use Phoenix.Component

  import KotkowoWeb.Components.Buttons
  import KotkowoWeb.Components.Icons
  import KotkowoWeb.Gettext
  import KotkowoWeb.WebHelpers, only: [beautify_phone_number: 1]
  import Tails

  alias Kotkowo.Client.Cat.Age
  alias Kotkowo.Client.Cat.MedicalStatus
  alias Kotkowo.Client.Cat.Sex
  alias Phoenix.LiveView.JS

  attr :src, :string, required: true, doc: "Image"
  attr :alt, :string, required: true, doc: "Image's alt"
  attr :share_href, :string, default: nil, doc: "Share link"
  attr :share_quote, :string, default: "", doc: "Text to include with most share options"

  attr :tags, :list,
    default: [],
    doc: "Tags",
    examples: [["Mruczek", "Wielbiciel kolan"], ["Meowy", "Loves laps"]]

  attr :class, :string, default: ""
  attr :img_class, :string, default: ""
  attr :img_anchor, :string, default: nil
  attr :body_class, :string, default: ""
  attr :grayscale, :boolean, default: false

  slot :title do
    attr :icon, :string, values: icons_all()
    attr :class, :string
  end

  attr :rest, :global

  slot(:attributes)
  slot(:actions)

  def card(assigns) do
    ~H"""
    <div
      class={
        classes([
          "lg:w-82 shrink-0 snap-center w-full max-w-xs lg:snap-none flex flex-col",
          @class
        ])
      }
      {@rest}
    >
      <div class="relative">
        <img
          :if={!@img_anchor}
          src={@src}
          alt={@alt}
          class={
            classes([
              "border border-1 rounded-t-2xl w-full object-cover h-48 text-base",
              @grayscale && "grayscale",
              @img_class
            ])
          }
        />

        <.link :if={@img_anchor} navigate={@img_anchor}>
          <img
            src={@src}
            alt={@alt}
            class={
              classes([
                "border border-1 rounded-t-2xl w-full object-cover h-48 text-base",
                @grayscale && "grayscale",
                @img_class
              ])
            }
          />
        </.link>
        <div :if={@share_href}>
          <div
            class="cursor-pointer absolute right-3 top-3 bg-white w-6 lg:w-10 h-6 lg:h-10 rounded-full opacity-60 flex"
            phx-click={JS.dispatch("share_modal")}
            share_href={@share_href}
            share_quote={@share_quote}
          >
            <.icon name="share" class="w-3 lg:w-5 h-3 lg:h-5 m-auto" />
          </div>
        </div>
      </div>

      <div class={
        classes([
          "bg-white rounded-3xl w-auto px-3 lg:px-5 py-2 lg:py-3 flex flex-col",
          "justify-between gap-y-3 pb-3 lg:pb-6 relative -mt-5 border border-1",
          @body_class
        ])
      }>
        <div :for={title <- @title} class="flex justify-between ">
          <h3 class={[
            "lg:font-manrope whitespace-nowrap font-semibold lg:font-bold text-lg lg:text-2xl overflow-x-auto",
            Map.get(title, :class)
          ]}>
            <%= render_slot(title) %>
          </h3>
          <.icon
            :if={Map.has_key?(title, :icon)}
            name={title.icon}
            class="w-5 lg:w-5.5 h-5 lg:h-5.5 my-auto"
          />
        </div>

        <%= render_slot(@attributes) %>

        <div
          :if={@tags != []}
          class="lg:mt-3 overflow-y-hidden overflow-x-hidden flex spacing space-x-1 whitespace-nowrap"
        >
          <.card_tag :for={tag <- @tags}><%= tag %></.card_tag>
        </div>

        <%= render_slot(@actions) %>
      </div>
    </div>
    """
  end

  attr :name, :string, required: true, doc: "Cat's name"
  attr :src, :string, required: true, doc: "Cat's image"
  attr :seniority, :atom, default: nil, values: Age.all() ++ [nil], doc: "Cat's seniority"

  attr :health_status, :atom,
    default: nil,
    values: MedicalStatus.all() ++ [nil],
    doc: "Cat's health status"

  attr :castrated, :boolean, default: nil, doc: "Whether cat was castrated"

  attr :tags, :list,
    default: [],
    doc: "Cat's tags",
    examples: [["Mruczek", "Wielbiciel kolan"], ["Meowy", "Loves laps"]]

  attr :sex, :atom, values: Sex.all(), required: true, doc: "Cat's sex"
  attr :share_href, :string, required: false, default: nil, doc: "Cat's share link"
  attr :share_quote, :string, default: "", doc: "Text included with share"
  attr :cat_url, :string, default: nil
  attr :dead, :boolean, default: false
  attr :card_class, :string, default: ""
  attr :rest, :global

  def cat_card(assigns) do
    assigns = assign(assigns, :name, assigns.name || "brak imiona")

    ~H"""
    <.card
      share_href={@share_href}
      share_quote={@share_quote}
      body_class="grow"
      class={
        classes([
          "only:mx-auto max-w-[240px] lg:max-w-none",
          @card_class
        ])
      }
      grayscale={@dead}
      src={@src}
      img_anchor={@cat_url}
      alt={@name}
      tags={@tags}
      {@rest}
    >
      <:title icon={to_string(@sex)}>
        <.link :if={@cat_url} navigate={@cat_url}><%= @name %></.link>
        <p :if={!@cat_url}><%= @name %></p>
      </:title>
      <:attributes>
        <.card_attribute :if={@seniority != nil} icon="paw">
          <%= Age.to_string(@seniority) %>
        </.card_attribute>
        <.card_attribute :if={@health_status != nil} icon="sthetoscope">
          <%= MedicalStatus.to_string(@health_status) %>
        </.card_attribute>
        <.card_attribute :if={@castrated != nil} icon="scissors">
          <%= (@castrated && gettext("Po kastracji")) || gettext("Przed kastracją") %>
        </.card_attribute>
      </:attributes>
    </.card>
    """
  end

  attr :icon, :string, default: nil, values: [nil | icons_all()]

  attr :rest, :global

  slot(:inner_block, required: true)

  def card_attribute(assigns) do
    ~H"""
    <div {@rest}>
      <.icon :if={@icon != nil} name={@icon} class="inline mr-1 lg:mr-3 w-4 lg:w-5 h-4 lg:h-5" />
      <span class="text-sm lg:text-base">
        <%= render_slot(@inner_block) %>
      </span>
    </div>
    """
  end

  slot(:inner_block, required: true)
  attr :class, :string, default: ""

  def card_tag(assigns) do
    ~H"""
    <span class={
      classes([
        "border border-2 rounded-3xl font-inter text-gray-500 text-sm lg:text-base py-2 lg:py-3 px-3 lg:px-4",
        @class
      ])
    }>
      <%= render_slot(@inner_block) %>
    </span>
    """
  end

  attr :name, :string, required: true, doc: "Cat's name"
  attr :src, :string, required: true, doc: "Cat's image"
  attr :sex, :atom, values: Sex.all(), required: true, doc: "Cat's sex"
  attr :share_href, :string, required: true, doc: "Cat's share link"
  attr :action_href, :string, required: true, doc: "Cat's adopt href"

  attr :tags, :list,
    default: [],
    doc: "Cat's tags",
    examples: [["Mruczek", "Wielbiciel kolan"], ["Meowy", "Loves laps"]]

  def virtual_adoption_card(assigns) do
    ~H"""
    <.card
      src={@src}
      alt={@name}
      tags={@tags}
      share_href={@share_href}
      body_class="lg:max-w-none max-w-[240px] grow lg:-mt-10"
      class="lg:w-[345px] lg:min-w-[345px] w-[240px]"
    >
      <:title icon={to_string(@sex)}>
        <%= @name %>
      </:title>
      <:actions>
        <.button class="xl:!px-6 xl:!text-base" navigate={@action_href}>
          <%= gettext("Adoptuj wirtualnie") %>
        </.button>
      </:actions>
    </.card>
    """
  end

  attr :src, :string, required: true, doc: "News' image"

  attr :tags, :list,
    default: [],
    doc: "News' tags",
    examples: [["Zbiórka", "Przedszkole"], ["Akcja", "Kastracja"]]

  attr :alt, :string, required: true
  attr :rest, :global, include: ~w(href navigate target rel)
  attr :img_class, :string, default: ""

  slot(:inner_block, required: true, doc: "Card's text")

  def help_card(assigns) do
    ~H"""
    <.link {@rest} class="flex grow">
      <div class="w-56 flex flex-col bg-white rounded-2xl snap-center lg:snap-none grow">
        <img
          src={@src}
          alt={@alt}
          class={classes(["rounded-t-2xl w-full h-40 object-contain", @img_class])}
        />

        <p class="flex py-5 px-6 text-center border rounded-b-2xl font-manrope font-bold grow justify-center items-center">
          <span><%= render_slot(@inner_block) %></span>
        </p>
      </div>
    </.link>
    """
  end

  attr :class, :string, default: ""
  attr :src, :string, required: true
  attr :title, :string, required: true
  attr :share_href, :string, required: false, default: nil, doc: "Cat's share link"
  attr :phone_numbers, :list, default: []
  attr :chip_number, :string, required: true
  attr :rest, :global
  attr :share_quote, :string, default: "", doc: "Text included with share"
  attr :cat_url, :string, default: nil

  def lost_and_found_card(assigns) do
    ~H"""
    <.card
      img_class="h-40"
      body_class="rounded-t-none -mt-0.5 grow lg:p-6 px-4 py-3 rounded-b-2xl"
      class="max-w-none lg:w-[345px] w-[240px] first:ml-auto last:mr-auto"
      share_href={@share_href}
      img_anchor={@cat_url}
      share_quote={@share_quote}
      src={@src}
      alt={@title}
      {@rest}
    >
      <:title class="!whitespace-normal lg:text-xl text-sm font-manrope font-bold tracking-wider text-left h-fit line-clamp-3">
        <.link :if={@cat_url} navigate={@cat_url}><%= @title %></.link>
        <p :if={!@cat_url}><%= @title %></p>
      </:title>
      <:attributes>
        <.card_attribute>
          <h3 class="text-primary font-bold text-sm lg:text-xl mb-2">Telefon</h3>
          <div class="flex flex-row gap-x-1 overflow-x-auto">
            <div
              :for={phone_number <- @phone_numbers}
              class="rounded-3xl border lg:border-2 border-primary p-2 lg:py-2 lg:px-3"
            >
              <a class="flex flex-row" href={"tel:+48#{phone_number}"}>
                <Heroicons.phone solid class="w-4 text-primary lg:mr-1" />
                <span class="font-inter text-xs lg:text-sm tracking-tighter lg:tracking-tight">
                  <%= phone_number |> beautify_phone_number() %>
                </span>
              </a>
            </div>
          </div>
        </.card_attribute>
        <.card_attribute>
          <h3 class="text-primary font-bold text-sm lg:text-xl mb-2">Numer chipa</h3>
          <div class="flex flex-row gap-x-1 overflow-x-auto">
            <div class="flex flex-row rounded-3xl border border-gray py-2 px-1 lg:px-3">
              <span class="font-inter text-xs lg:text-sm tracking-tight">
                <%= @chip_number || "Brak" %>
              </span>
            </div>
          </div>
        </.card_attribute>
      </:attributes>
    </.card>
    """
  end

  attr :class, :string, default: ""
  attr :bottom_class, :string, default: ""

  def card_loading(assigns) do
    ~H"""
    <div>
      <div class={
        classes([
          "h-[192px] lg:min-w-[320px] min-w-[280px] bg-gray-300 animate-pulse rounded-t-2xl",
          @class
        ])
      }>
      </div>

      <div class={
        classes([
          "h-[95px] lg:min-w-[320px] min-w-[280px] bg-gray-400 animate-pulse rounded-b-2xl",
          @bottom_class
        ])
      }>
      </div>
    </div>
    """
  end

  attr :class, :string, default: ""
  attr :card_class, :string, default: ""
  attr :src, :string, required: true
  attr :title, :string, required: true
  attr :media_url, :string, required: true

  attr :tags, :list,
    default: [],
    doc: "Tags",
    examples: [["Mruczek", "Wielbiciel kolan"], ["Meowy", "Loves laps"]]

  def external_media_card(assigns) do
    ~H"""
    <.card
      src={@src}
      alt={@title}
      tags={Enum.take(@tags, 2)}
      body_class="rounded-t-none rounded-b-2xl grow py-4 mt-0"
      class={classes(["lg:min-w-[345px] min-w-[240px] w-[240px] only:mx-auto", @card_class])}
    >
      <:title class="lg:text-xl text-base grow line-clamp-3 !whitespace-normal">
        <.link href={@media_url} rel="noopener noreferrer" target="_blank">
          <%= @title %>
        </.link>
      </:title>
    </.card>
    """
  end

  attr :class, :string, default: ""
  attr :card_class, :string, default: ""
  attr :src, :string, required: true
  attr :title, :string, required: true
  attr :news_id, :string, required: true

  attr :tags, :list,
    default: [],
    doc: "Tags",
    examples: [["Mruczek", "Wielbiciel kolan"], ["Meowy", "Loves laps"]]

  def news_card(assigns) do
    ~H"""
    <.card
      src={@src}
      alt={@title}
      tags={Enum.take(@tags, 2)}
      body_class="rounded-t-none rounded-b-2xl grow py-4 mt-0"
      class={classes(["lg:min-w-[345px] min-w-[240px] w-[240px] only:mx-auto", @card_class])}
    >
      <:title class="lg:text-xl text-base grow line-clamp-3 !whitespace-normal">
        <.link navigate={~p"/aktualnosci/z-ostatniej-chwili/#{assigns.news_id}"}>
          <%= @title %>
        </.link>
      </:title>
    </.card>
    """
  end

  attr :class, :string, default: ""

  def news_card_loading(assigns) do
    ~H"""
    <.card_loading
      bottom_class={classes(["h-[192px]", @class])}
      class={classes(["h-[192px]", @class])}
    />
    """
  end

  def header_news_card_loading(assigns) do
    ~H"""
    <div class="lg:w-[1312px] flex flex-col lg:flex-row border border-1 rounded-2xl items-start h-full lg:h-[322px] pt-6 lg:pt-0">
      <div class="flex flex-col w-full">
        <div
          :for={_ <- 1..6}
          class="mt-2 max-w-xl even:max-w-lg first:mt-6 first:mb-4 mx-6 h-6 first:h-8 bg-gray-300 animate-pulse w-full rounded"
        >
        </div>
      </div>
      <div class="bg-gray-300 animate-pulse w-full lg:max-w-[535px] lg:h-full rounded-xl lg:rounded-l-none lg:rounded-y-none">
      </div>
    </div>
    """
  end

  slot :introduction

  attr :title, :string, required: true
  attr :tags, :list, default: []
  attr :image, :string, required: true
  attr :news_id, :string, required: true

  def header_news_card(assigns) do
    ~H"""
    <div class="lg:w-[1312px] flex flex-col lg:flex-row justify-between border border-1 rounded-2xl items-start h-full lg:h-[322px] pt-6 lg:pt-0">
      <div class="flex flex-col px-6 lg:py-6 max-w-xl h-full lg:gap-y-0 gap-y-4">
        <div class="text-2xl font-semibold leading-10 lg:line-clamp-2 line-clamp-5">
          <.link navigate={~p"/aktualnosci/z-ostatniej-chwili/#{assigns.news_id}"}>
            <%= @title %>
          </.link>
        </div>
        <p class="text-lg h-32 leading-10 line-clamp-6 lg:line-clamp-3 lg:px-0">
          <%= render_slot(@introduction) %>
        </p>
        <div
          :if={@tags != []}
          class="lg:mt-3 overflow-y-auto flex spacing space-x-1 whitespace-nowrap"
        >
          <.card_tag :for={tag <- @tags}><%= tag %></.card_tag>
        </div>
      </div>
      <.link
        class="h-full w-full lg:w-fit mt-10 lg:mt-0"
        navigate={~p"/aktualnosci/z-ostatniej-chwili/#{assigns.news_id}"}
      >
        <img
          class="w-full lg:w-[535px] h-[169px]  lg:h-full object-cover rounded-xl  lg:rounded-l-none lg:rounded-y-none"
          src={@image}
          alt="Latest news image"
        />
      </.link>
    </div>
    """
  end

  def view_cat_loading(assigns) do
    ~H"""
    <div class="hidden lg:block">
      <div class="animate-pulse bg-gray-300 w-64 h-12 mx-4 xl:mb-12 mb-6 rounded"></div>
      <div class="flex flex-row xl:gap-x-32 xl:gap-y-12">
        <div class="flex flex-col">
          <div class="min-w-[868px] min-h-[485px] animate-pulse bg-gray-300"></div>
          <div class="flex flex-row gap-x-2 mt-2">
            <div :for={_ <- 0..3} class="w-20 h-[45px] animate-pulse bg-gray-300"></div>
          </div>
          <div class="flex flex-col gap-y-4 mt-16">
            <div class="w-[600px] rounded-lg animate-pulse h-8 bg-gray-300"></div>
            <div class="flex flex-col gap-y-2">
              <div class="w-[800px] rounded-lg animate-pulse h-6 bg-gray-300"></div>
              <div class="w-[600px] rounded-lg animate-pulse h-6 bg-gray-300"></div>
              <div class="w-[700px] rounded-lg animate-pulse h-6 bg-gray-300"></div>
              <div class="w-[800px] rounded-lg animate-pulse h-6 bg-gray-300"></div>
              <div class="w-[300px] rounded-lg animate-pulse h-6 bg-gray-300"></div>
            </div>
          </div>
        </div>

        <div class="min-w-[280px] flex flex-col gap-y-4">
          <div class="w-86 h-12 mb-2 animate-pulse bg-gray-300 rounded"></div>
          <div class="w-16 h-8 animate-pulse bg-gray-300 rounded"></div>
          <div class="w-32 h-8 animate-pulse bg-gray-300 rounded"></div>
          <div class="w-64 h-8 animate-pulse bg-gray-300 rounded"></div>
          <div class="w-36 h-8 animate-pulse bg-gray-300 rounded"></div>
          <div class="w-64 h-8 animate-pulse bg-gray-300 rounded"></div>
          <div class="flex flex-row flex-wrap gap-3">
            <div class="w-36 h-10 rounded-3xl animate-pulse bg-gray-300"></div>
            <div class="w-32 h-10 rounded-3xl animate-pulse bg-gray-300"></div>
            <div class="w-32 h-10 rounded-3xl animate-pulse bg-gray-300"></div>
            <div class="w-24 h-10 rounded-3xl animate-pulse bg-gray-300"></div>
            <div class="w-24 h-10 rounded-3xl animate-pulse bg-gray-300"></div>
            <div class="w-32 h-10 rounded-3xl animate-pulse bg-gray-300"></div>
            <div class="w-64 h-12 rounded-3xl animate-pulse bg-gray-300"></div>
          </div>
          <div class="flex flex-col gap-y-4 mt-16">
            <div class="animate-pulse bg-gray-300 h-8 w-64 rounded-lg"></div>
            <div class="animate-pulse bg-gray-300 h-6 w-56 rounded-lg"></div>
            <div class="animate-pulse bg-gray-300 h-6 w-56 rounded-lg"></div>
            <div class="animate-pulse bg-gray-300 h-6 w-56 rounded-lg"></div>
            <div class="flex flex-row gap-x-2">
              <div class="w-32 rounded-2xl h-9 animate-pulse bg-gray-300"></div>
              <div class="w-32 rounded-2xl h-9 animate-pulse bg-gray-300"></div>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end

  attr :asset, :string

  def assets_box(assigns) do
    ~H"""
    <div class="flex flex-col min-w-[246px] w-[246px] snap-center">
      <div class="bg-primary-light h-[158px] rounded-t-2xl w-full">
        <img class="w-full h-full object-fit" src={~p"/images/#{@asset}"} alt={@asset} />
      </div>
      <div class="px-4 items-center flex flex-row justify-between bg-white h-[60px] border-b-2 border-x-2 border-gray-200 rounded-b-2xl rounded-x-2xl w-full">
        <span><%= @asset %></span>
        <a download href={~p"/images/#{@asset}"} target="_blank" rel="noopener noreferrer">
          <.icon name="download" class="w-4 text-black" />
        </a>
      </div>
    </div>
    """
  end

  attr :href, :string
  attr :title, :string
  attr :external, :boolean, required: false
  attr :type, :string, required: false

  def download_card(%{external: _} = assigns) do
    ~H"""
    <div class="flex flex-row items-center justify-between border h-14 w-[313px] border-gray-300 p-4 rounded-2xl">
      <span class="font-manrope font-bold"><%= @title %></span>
      <a target="_blank" rel="noopener noreferrer" href={@href}>
        <.icon name="external_link" class="text-black h-3 w-3" />
      </a>
    </div>
    """
  end

  def download_card(assigns) do
    ~H"""
    <div class="flex flex-row items-center justify-between border h-14 w-[313px] border-gray-300 p-4 rounded-2xl">
      <span class="font-manrope font-bold"><%= @title %></span>
      <a href={@href} download><.icon name="download" class="text-black h-4 w-4" /></a>
    </div>
    """
  end
end
