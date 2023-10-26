defmodule KotkowoWeb.Components.Cards do
  @moduledoc """
  Provides card UI components.
  """

  use KotkowoWeb, :verified_routes
  use Phoenix.Component

  import KotkowoWeb.Components.Buttons
  import KotkowoWeb.Components.Icons
  import KotkowoWeb.Gettext
  import Tails

  alias Kotkowo.Attributes.HealthStatus
  alias Kotkowo.Attributes.Seniority
  alias Kotkowo.Attributes.Sex

  attr :src, :string, required: true, doc: "Image"
  attr :alt, :string, required: true, doc: "Image's alt"
  attr :share_href, :string, default: nil, doc: "Share link"

  attr :tags, :list,
    default: [],
    doc: "Tags",
    examples: [["Mruczek", "Wielbiciel kolan"], ["Meowy", "Loves laps"]]

  attr :class, :string, default: ""
  attr :body_class, :string, default: ""
  attr :grayscale, :boolean, default: false

  slot :title do
    attr :icon, :string, values: icons_all()
    attr :class, :string
  end

  slot(:attributes)
  slot(:actions)

  def card(assigns) do
    ~H"""
    <div class={classes(["w-60 lg:w-82 shrink-0 snap-center lg:snap-none flex flex-col", @class])}>
      <div class="relative">
        <img
          src={@src}
          alt={@alt}
          class={[
            "border border-1 rounded-t-2xl w-full object-cover h-48",
            @grayscale && "grayscale"
          ]}
        />
        <a
          :if={@share_href != nil}
          href={@share_href}
          class="absolute right-3 top-3 bg-white w-6 lg:w-10 h-6 lg:h-10 rounded-full lg:opacity-60 flex"
        >
          <.icon name="share" class="w-3 lg:w-5 h-3 lg:h-5 m-auto" />
        </a>
      </div>

      <div class={
        classes([
          "bg-white rounded-3xl w-auto px-3 lg:px-5 py-2 lg:py-3 flex flex-col",
          "gap-y-3 pb-3 lg:pb-6 relative -mt-5 border border-1",
          @body_class
        ])
      }>
        <div :for={title <- @title} class="flex justify-between flex-1">
          <h3 class={[
            "lg:font-manrope font-semibold lg:font-bold text-lg lg:text-2xl",
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
          class="lg:mt-3 overflow-y-auto flex spacing space-x-1 whitespace-nowrap"
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
  attr :seniority, :atom, default: nil, values: Seniority.all() ++ [nil], doc: "Cat's seniority"

  attr :health_status, :atom,
    default: nil,
    values: HealthStatus.all() ++ [nil],
    doc: "Cat's health status"

  attr :castrated, :boolean, default: nil, doc: "Whether cat was castrated"

  attr :tags, :list,
    default: [],
    doc: "Cat's tags",
    examples: [["Mruczek", "Wielbiciel kolan"], ["Meowy", "Loves laps"]]

  attr :sex, :atom, values: Sex.all(), required: true, doc: "Cat's sex"
  attr :share_href, :string, required: true, doc: "Cat's share link"
  attr :dead, :boolean, default: false

  def cat_card(assigns) do
    ~H"""
    <.card share_href={@share_href} grayscale={@dead} src={@src} alt={@name} tags={@tags}>
      <:title icon={to_string(@sex)}>
        <%= @name %>
      </:title>
      <:attributes>
        <.card_attribute :if={@seniority != nil} icon="paw">
          <%= Seniority.to_string(@seniority) %>
        </.card_attribute>
        <.card_attribute :if={@health_status != nil} icon="sthetoscope">
          <%= HealthStatus.to_string(@health_status) %>
        </.card_attribute>
        <.card_attribute :if={@castrated != nil} icon="scissors">
          <%= (@castrated && gettext("Po kastracji")) || gettext("Przed kastracją") %>
        </.card_attribute>
      </:attributes>
    </.card>
    """
  end

  attr :icon, :string, required: true, values: icons_all()

  attr :rest, :global

  slot(:inner_block, required: true)

  def card_attribute(assigns) do
    ~H"""
    <div {@rest}>
      <.icon name={@icon} class="inline mr-1 lg:mr-3 w-4 lg:w-5 h-4 lg:h-5" />
      <span class="text-sm lg:text-base">
        <%= render_slot(@inner_block) %>
      </span>
    </div>
    """
  end

  slot(:inner_block, required: true)

  def card_tag(assigns) do
    ~H"""
    <span class="border border-2 rounded-3xl text-gray-500 text-sm lg:text-base py-2 lg:py-3 px-3 lg:px-4">
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
    <.card src={@src} alt={@name} tags={@tags} share_href={@share_href}>
      <:title icon={to_string(@sex)}>
        <%= @name %>
      </:title>
      <:actions>
        <.button class="xl:!px-6 xl:!text-base" href={@action_href}>
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

  attr :href, :string, required: true
  attr :alt, :string, required: true

  slot(:inner_block, required: true, doc: "Card's text")

  def help_card(assigns) do
    ~H"""
    <a href={@href} class="flex grow">
      <div class="w-56 flex flex-col bg-white rounded-2xl border border-2 snap-center lg:snap-none grow">
        <img src={@src} alt={@alt} class="border border-1 rounded-t-2xl w-full object-cover h-40" />

        <p class="flex py-5 px-6 text-center font-manrope font-bold grow justify-center items-center">
          <span><%= render_slot(@inner_block) %></span>
        </p>
      </div>
    </a>
    """
  end

  attr :href, :string, required: true
  attr :src, :string, required: true
  attr :alt, :string, required: true

  slot(:inner_block, required: true, doc: "Card's text")

  def external_site_help_card(assigns) do
    ~H"""
    <a href="#">
      <div class="w-72 flex flex-col bg-white rounded-2xl border border-2 snap-center lg:snap-none">
        <img src={@src} alt={@alt} class="object-scale-down my-5 h-16" />

        <p class="pb-6 px-6 text-center font-manrope font-bold">
          <%= render_slot(@inner_block) %>
        </p>
      </div>
    </a>
    """
  end

  attr :class, :string, default: ""
  attr :src, :string, required: true
  attr :title, :string, required: true
  attr :news_id, :string, required: true

  attr :tags, :list,
    default: [],
    doc: "Tags",
    examples: [["Mruczek", "Wielbiciel kolan"], ["Meowy", "Loves laps"]]

  def news_card(assigns) do
    ~H"""
    <.link navigate={~p"/aktualnosci/z-ostatniej-chwili/#{@news_id}"}>
      <.card
        src={@src}
        alt={@title}
        tags={Enum.take(@tags, 2)}
        body_class="rounded-t-none grow py-4"
        class={classes(["grow lg:w-[345px] h-full", @class])}
      >
        <:title class="lg:text-xl grow line-clamp-3"><%= @title %></:title>
      </.card>
    </.link>
    """
  end

  def header_news_card(assigns) do
    ~H"""
    <.link
      navigate={~p"/aktualnosci/z-ostatniej-chwili/#{assigns.news_id}"}
      class="lg:w-[1312px] flex flex-col lg:flex-row justify-between border border-1 border rounded-2xl items-start h-full lg:h-[322px] pt-6 lg:pt-0"
    >
      <div class="flex flex-col pl-6 lg:py-6 max-w-xl h-full">
        <div class="text-2xl font-semibold leading-10 line-clamp-2">
          <%= @title %>
        </div>
        <p class="py-2 text-lg leading-10 grow line-clamp-6 lg:line-clamp-4 px-2 lg:px-0">
          <%= @introduction %>
        </p>
        <div
          :if={@tags != []}
          class="lg:mt-3 overflow-y-auto flex spacing space-x-1 whitespace-nowrap"
        >
          <.card_tag :for={tag <- @tags}><%= tag %></.card_tag>
        </div>
      </div>
      <img
        class="w-full mt-5 lg:mt-0 lg:w-[535px] h-[169px]  lg:h-full object-cover rounded-xl  lg:rounded-l-none lg:rounded-y-none"
        src={@image}
        alt="Latest news image"
      />
    </.link>
    """
  end
end
