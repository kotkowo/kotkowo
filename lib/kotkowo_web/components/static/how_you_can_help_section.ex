defmodule KotkowoWeb.Components.Static.HowYouCanHelpSection do
  use Phoenix.Component
  use Phoenix.VerifiedRoutes, endpoint: KotkowoWeb.Endpoint, router: KotkowoWeb.Router

  import KotkowoWeb.Components.Cards
  import KotkowoWeb.Components.Sections

  attr(:fold, :boolean,
    default: true,
    doc: "Whether should fold into horizontaly scrollable"
  )

  slot :inner_block, required: true

  defp container(assigns) do
    ~H"""
    <%= if @fold do %>
      <div class="flex w-full mx-2">
        <div
          class="overflow-x-auto snap-x lg:snap-none lg:mx-auto"
          x-init="$el.scrollLeft = ($el.scrollWidth - $el.clientWidth) / 2;"
        >
          <div class="flex flex-row space-x-4 xl:space-x-7 m-auto">
            <%= render_slot(@inner_block) %>
          </div>
        </div>
      </div>
    <% else %>
      <div class="flex w-full">
        <div class="flex flex-col xl:flex-row xl:space-x-5 mx-auto gap-y-5 xl:gap-y-0">
          <%= render_slot(@inner_block) %>
        </div>
      </div>
    <% end %>
    """
  end

  attr(:fold, :boolean,
    default: true,
    doc: "Whether should fold into horizontaly scrollable"
  )

  def how_you_can_help(assigns) do
    ~H"""
    <.section>
      <h1 class="text-primary mb-8 font-manrope font-extrabold xl:text-4xl text-2xl text-center">
        Jak możesz pomóc?
      </h1>

      <.container fold={@fold}>
        <.help_card href="#" src={~p"/images/heart_lend.png"} alt="Heart lending">
          Przekaż nam 1% podatku
        </.help_card>

        <.help_card href="#" src={~p"/images/piggy_bank.png"} alt="Piggy bank">
          Wesprzyj nas finansowo
        </.help_card>

        <.help_card href="#" src={~p"/images/spices.png"} alt="Food">
          Przekaż rzeczy dla kotków
        </.help_card>

        <.help_card href="#" src={~p"/images/cat_on_couch.png"} alt="Cat on couch">
          Stwórz dom tymczasowy
        </.help_card>

        <.help_card href="#" src={~p"/images/cat_food.png"} alt="Cat food">
          Zorganizuj zbiórkę
        </.help_card>
      </.container>
    </.section>
    """
  end
end
