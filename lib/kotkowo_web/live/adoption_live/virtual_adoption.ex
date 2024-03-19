defmodule KotkowoWeb.AdoptionLive.VirtualAdoption do
  @moduledoc false
  use KotkowoWeb, :live_view

  import KotkowoWeb.Components.Sections
  import KotkowoWeb.Components.Static.HowYouCanHelpSection
  import KotkowoWeb.Components.Steps
  import Tails

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  defp portrait(assigns) do
    ~H"""
    <div class="lg:w-[202px] w-20 pt-9 flex flex-col items-center">
      <img
        src={@portait_image}
        class="lg:w-[160px] w-20 h-20  object-cover lg:h-[160px] rounded-full"
      />

      <h2 class="font-manrope line-clamp-1 text-center mt-4 font-bold text-lg lg:text-2xl mb-4">
        <%= @portait_name %>
      </h2>
    </div>
    """
  end

  attr :class, :string, default: ""
  attr :person_image, :string, required: true
  attr :cat_image, :string, required: true
  attr :person_name, :string, required: true
  attr :cat_name, :string, required: true

  defp supporting_card(assigns) do
    ~H"""
    <div class="w-full">
      <div class={
        classes([
          "bg-primary-light relative lg:px-0 px-6 w-[279px] h-[166px] lg:w-[423px] lg:h-[297px] flex-row flex items-center justify-between rounded-2xl",
          @class
        ])
      }>
        <.icon
          name="arrow_right"
          class="absolute left-1/2 top-1/3 transform -translate-x-1/2 translate-y-1/2"
        />
        <.portrait portait_name={@person_name} portait_image={@person_image} />
        <.portrait portait_name={@cat_name} portait_image={@cat_image} />
      </div>
    </div>
    """
  end

  attr :card_class, :string, default: ""

  defp people_supporting(assigns) do
    ~H"""
    <.section class="!max-w-none">
      <div
        class="overflow-x-auto overflow-y-hidden self-center snap-x lg:snap-none"
        x-init="$el.scrollLeft = ($el.scrollWidth - $el.clientWidth) / 2;"
      >
        <div class="flex-row flex gap-x-5 w-full mx-auto">
          <.supporting_card
            class={@card_class}
            person_name="Kasia"
            person_image={~p"/images/supporting_kasia.jpg"}
            cat_image={~p"/images/bonifacy.png"}
            cat_name="Bonifacy"
          />
          <.supporting_card
            class={@card_class}
            person_name="Kasia"
            person_image={~p"/images/supporting_kasia.jpg"}
            cat_image={~p"/images/bonifacy.png"}
            cat_name="Bonifacy"
          />

          <.supporting_card
            class={@card_class}
            person_name="Kasia"
            person_image={~p"/images/supporting_kasia.jpg"}
            cat_image={~p"/images/bonifacy.png"}
            cat_name="Bonifacy"
          />

          <.supporting_card
            class={@card_class}
            person_name="Kasia"
            person_image={~p"/images/supporting_kasia.jpg"}
            cat_image={~p"/images/bonifacy.png"}
            cat_name="Bonifacy"
          />

          <.supporting_card
            class={@card_class}
            person_name="Kasia"
            person_image={~p"/images/supporting_kasia.jpg"}
            cat_image={~p"/images/bonifacy.png"}
            cat_name="Bonifacy"
          />

          <.supporting_card
            class={@card_class}
            person_name="Bonifacy"
            person_image={~p"/images/supporting_kasia.jpg"}
            cat_image={~p"/images/bonifacy.png"}
            cat_name="Bonifacy"
          />
        </div>
      </div>
      <.button class="mt-8 mx-auto flex">Zostań wirtualnym opiekunem</.button>
    </.section>
    """
  end
end
