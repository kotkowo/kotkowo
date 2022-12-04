defmodule KotkowoWeb.Components.Cards do
  @moduledoc """
  Provides card UI components.
  """

  use Phoenix.Component
  use Phoenix.VerifiedRoutes, endpoint: KotkowoWeb.Endpoint, router: KotkowoWeb.Router

  import KotkowoWeb.Gettext

  import KotkowoWeb.Components.Icons
  import KotkowoWeb.Components.Buttons

  alias Kotkowo.Attributes.Seniority
  alias Kotkowo.Attributes.HealthStatus
  alias Kotkowo.Attributes.Sex

  attr(:src, :string, required: true, doc: "Image")
  attr(:alt, :string, required: true, doc: "Image's alt")
  attr(:share_href, :string, default: nil, doc: "Share link")

  attr(:tags, :list,
    default: [],
    doc: "Tags",
    examples: [["Mruczek", "Wielbiciel kolan"], ["Meowy", "Loves laps"]]
  )

  attr :body_class, :string, default: ""

  slot :title do
    attr :icon, :string, values: icons_all()
    attr :class, :string
  end

  slot(:attributes)
  slot(:actions)

  def card(assigns) do
    ~H"""
    <div class="w-60 lg:w-82 shrink-0 snap-center lg:snap-none flex flex-col">
      <div class="relative">
        <a
          :if={@share_href != nil}
          href={@share_href}
          class="absolute right-3 top-3 bg-white w-6 lg:w-10 h-6 lg:h-10 rounded-full lg:opacity-60 flex"
        >
          <.icon name="share" class="w-3 lg:w-5 h-3 lg:h-5 m-auto" />
        </a>
        <img src={@src} alt={@alt} class="border border-1 rounded-t-2xl w-full object-cover h-48" />
      </div>

      <div class={[
        "bg-white rounded-3xl w-auto px-3 lg:px-5 py-2 lg:py-3 flex flex-col",
        "gap-y-3 pb-3 lg:pb-6 relative -mt-5 border border-1 flex-1",
        @body_class
      ]}>
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

  attr(:name, :string, required: true, doc: "Cat's name")
  attr(:src, :string, required: true, doc: "Cat's image")
  attr(:seniority, :atom, required: true, values: Seniority.all(), doc: "Cat's seniority")

  attr(:health_status, :atom,
    required: true,
    values: HealthStatus.all(),
    doc: "Cat's health status"
  )

  attr(:castrated, :boolean, required: true, doc: "Whether cat was castrated")

  attr(:tags, :list,
    default: [],
    doc: "Cat's tags",
    examples: [["Mruczek", "Wielbiciel kolan"], ["Meowy", "Loves laps"]]
  )

  attr(:sex, :atom, values: Sex.all(), required: true, doc: "Cat's sex")
  attr(:share_href, :string, required: true, doc: "Cat's share link")

  def cat_card(assigns) do
    ~H"""
    <.card share_href={@share_href} src={@src} alt={@name} tags={@tags}>
      <:title icon={to_string(@sex)}>
        <%= @name %>
      </:title>
      <:attributes>
        <.card_attribute icon="paw">
          <%= Seniority.to_string(@seniority) %>
        </.card_attribute>
        <.card_attribute icon="sthetoscope">
          <%= HealthStatus.to_string(@health_status) %>
        </.card_attribute>
        <.card_attribute icon="scissors">
          <%= (@castrated && gettext("Po kastracji")) || gettext("Przed kastracją") %>
        </.card_attribute>
      </:attributes>
    </.card>
    """
  end

  attr(:icon, :string, required: true, values: icons_all())

  attr(:rest, :global)

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

  attr(:name, :string, required: true, doc: "Cat's name")
  attr(:src, :string, required: true, doc: "Cat's image")
  attr(:sex, :atom, values: Sex.all(), required: true, doc: "Cat's sex")
  attr(:share_href, :string, required: true, doc: "Cat's share link")
  attr(:action_href, :string, required: true, doc: "Cat's adopt href")

  attr(:tags, :list,
    default: [],
    doc: "Cat's tags",
    examples: [["Mruczek", "Wielbiciel kolan"], ["Meowy", "Loves laps"]]
  )

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

  attr(:title, :string, required: true, doc: "News' title")
  attr(:src, :string, required: true, doc: "News' image")

  attr(:tags, :list,
    default: [],
    doc: "News' tags",
    examples: [["Zbiórka", "Przedszkole"], ["Akcja", "Kastracja"]]
  )

  def news_card(assigns) do
    ~H"""
    <.card src={@src} alt={@title} tags={@tags} body_class="rounded-t-none">
      <:title class="lg:!text-xl">
        <%= @title %>
      </:title>
    </.card>
    """
  end

  attr :href, :string, required: true
  attr :src, :string, required: true
  attr :alt, :string, required: true

  slot :inner_block, required: true, doc: "Card's text"

  def help_card(assigns) do
    ~H"""
    <a href="#">
      <div class="w-60 flex flex-col bg-white rounded-2xl border border-2">
        <img src={@src} alt={@alt} class="border border-1 rounded-t-2xl w-full object-cover h-40" />

        <p class="py-5 px-14 text-center font-manrope font-bold"><%= render_slot(@inner_block) %></p>
      </div>
    </a>
    """
  end
end
