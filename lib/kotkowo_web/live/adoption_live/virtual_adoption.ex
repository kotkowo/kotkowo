defmodule KotkowoWeb.AdoptionLive.VirtualAdoption do
  @moduledoc false
  use KotkowoWeb, :live_view

  import KotkowoWeb.Components.Sections
  import KotkowoWeb.Components.Static.HowYouCanHelpSection
  import KotkowoWeb.Components.Steps

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  defp portrait(assigns) do
    ~H"""
    <div class="w-[202px] h-full pt-9 flex flex-col items-center">
      <img src={@portait_image} class="w-[160px]  object-cover h-[160px] rounded-full" />

      <h2 class="font-manrope text-center mt-4 font-bold text-2xl mb-4">
        <%= @portait_name %>
      </h2>
    </div>
    """
  end

  defp supporting_card(assigns) do
    ~H"""
    <div class="bg-primary-light relative w-[423px] h-[297px] flex-row flex items-center justify-between rounded-2xl">
      <.icon
        name="arrow_right"
        class="absolute left-1/2 top-1/3 transform -translate-x-1/2 translate-y-1/2"
      />
      <.portrait portait_name={@person_name} portait_image={@person_image} />
      <.portrait portait_name={@cat_name} portait_image={@cat_image} />
    </div>
    """
  end

  defp people_supporting(assigns) do
    ~H"""
    <.section class="!max-w-none">
      <div
        class=" overflow-x-auto self-center"
        x-init="$el.scrollLeft = ($el.scrollWidth - $el.clientWidth) / 2;"
      >
        <div class="flex-row flex gap-x-5 w-full mx-auto ">
          <.supporting_card
            person_name="Kasia"
            person_image={~p"/images/supporting_kasia.jpg"}
            cat_image={~p"/images/bonifacy.png"}
            cat_name="Bonifacy"
          />
          <.supporting_card
            person_name="Kasia"
            person_image={~p"/images/supporting_kasia.jpg"}
            cat_image={~p"/images/bonifacy.png"}
            cat_name="Bonifacy"
          />

          <.supporting_card
            person_name="Kasia"
            person_image={~p"/images/supporting_kasia.jpg"}
            cat_image={~p"/images/bonifacy.png"}
            cat_name="Bonifacy"
          />

          <.supporting_card
            person_name="Kasia"
            person_image={~p"/images/supporting_kasia.jpg"}
            cat_image={~p"/images/bonifacy.png"}
            cat_name="Bonifacy"
          />

          <.supporting_card
            person_name="Kasia"
            person_image={~p"/images/supporting_kasia.jpg"}
            cat_image={~p"/images/bonifacy.png"}
            cat_name="Bonifacy"
          />

          <.supporting_card
            person_name="Kasia"
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
