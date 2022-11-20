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
    <div class="w-60 lg:w-82 shrink-0 snap-center lg:snap-none">
      <div class="relative">
        <a
          href={@share_href}
          class="absolute right-3 top-3 bg-white w-6 lg:w-10 h-6 lg:h-10 rounded-full lg:opacity-60 flex"
        >
          <.icon_share class="w-3 lg:w-5 h-3 lg:h-5 m-auto" />
        </a>
        <img src={@src} alt={@name} class="border border-1 rounded-t-2xl w-full object-cover h-48" />
      </div>

      <div class="bg-white rounded-3xl w-auto px-3 lg:px-5 py-2 lg:py-3 flex flex-col gap-y-3 pb-3 lg:pb-6 relative -mt-5 border border-1">
        <div class="flex justify-between">
          <h3 class="lg:font-manrope font-semibold lg:font-bold text-lg lg:text-2xl"><%= @name %></h3>
          <%= if @sex == :male do %>
            <.icon_male class="w-5 lg:w-5.5 h-5 lg:h-5.5 my-auto" />
          <% else %>
            <.icon_female class="w-5 lg:w-5.5 h-5 lg:h-5.5 my-auto" />
          <% end %>
        </div>

        <div>
          <.icon_paw class="inline mr-1 lg:mr-3 w-4 lg:w-5 h-4 lg:h-5" />
          <span class="text-sm lg:text-base"><%= Seniority.to_string(@seniority) %></span>
        </div>
        <div>
          <.icon_sthetoscope class="inline mr-1 lg:mr-3 w-4 lg:w-5 h-4 lg:h-5" />
          <span class="text-sm lg:text-base"><%= HealthStatus.to_string(@health_status) %></span>
        </div>
        <div>
          <.icon_scissors class="inline mr-1 lg:mr-3 w-4 lg:w-5 h-4 lg:h-5" />
          <span class="text-sm lg:text-base">
            <%= (@castrated && gettext("Po kastracji")) || gettext("Przed kastracją") %>
          </span>
        </div>

        <div
          :if={@tags != []}
          class="lg:mt-3 overflow-y-auto flex spacing space-x-1 whitespace-nowrap"
        >
          <%= for tag <- @tags do %>
            <span class="border border-2 rounded-3xl text-gray-500 text-sm lg:text-base py-2 lg:py-3 px-3 lg:px-4">
              <%= tag %>
            </span>
          <% end %>
        </div>
      </div>
    </div>
    """
  end
end
