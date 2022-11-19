defmodule KotkowoWeb.Components.Cards do
  @moduledoc """
  Provides card UI components.
  """

  use Phoenix.Component
  use Phoenix.VerifiedRoutes, endpoint: KotkowoWeb.Endpoint, router: KotkowoWeb.Router

  import KotkowoWeb.Gettext

  import KotkowoWeb.Components.Icons

  alias Kotkowo.Attributes.Seniority
  alias Kotkowo.Attributes.HealthStatus
  alias Kotkowo.Attributes.Sex

  attr :name, :string, required: true, doc: "Cat's name"
  attr :src, :string, required: true, doc: "Cat's image"
  attr :seniority, :atom, required: true, values: Seniority.all(), doc: "Cat's seniority"

  attr :health_status, :atom,
    required: true,
    values: HealthStatus.all(),
    doc: "Cat's health status"

  attr :castrated, :boolean, required: true, doc: "Whether cat was castrated"

  attr :tags, :list,
    default: [],
    doc: "Cat's tags",
    examples: [["Mruczek", "Wielbiciel kolan"], ["Meowy", "Loves laps"]]

  attr :sex, :atom, values: Sex.all(), required: true, doc: "Cat's sex"
  attr :share_href, :string, required: true, doc: "Cat's share link"

  def cat_card(assigns) do
    ~H"""
    <div class="w-82 shrink-0 snap-center xl:snap-none">
      <div class="relative">
        <a href={@share_href} class="absolute right-3 top-3 bg-white p-2.5 rounded-full opacity-60">
          <.icon_share />
        </a>
        <img src={@src} alt={@name} class="border border-1 rounded-t-2xl w-full object-cover h-48" />
      </div>

      <div class="bg-white rounded-3xl w-auto px-5 py-3 flex flex-col gap-y-3 pb-6 relative -mt-5 border border-1">
        <div class="flex justify-between">
          <h3 class="font-bold text-3xl"><%= @name %></h3>
          <%= if @sex == :male do %>
            <.icon_male class="h-6 my-auto" />
          <% else %>
            <.icon_female class="h-6 my-auto" />
          <% end %>
        </div>

        <div>
          <.icon_paw class="inline mr-2" />
          <%= Seniority.to_string(@seniority) %>
        </div>
        <div>
          <.icon_sthetoscope class="inline mr-2" />
          <%= HealthStatus.to_string(@health_status) %>
        </div>
        <div>
          <.icon_scissors class="inline mr-2" />
          <%= (@castrated && gettext("Po kastracji")) || gettext("Przed kastracją") %>
        </div>

        <div :if={@tags != []} class="mt-3">
          <%= for tag <- @tags do %>
            <span class="border border-2 rounded-3xl p-3"><%= tag %></span>
          <% end %>
        </div>
      </div>
    </div>
    """
  end
end
