defmodule KotkowoWeb.Components.Static.HowYouCanHelpSection do
  @moduledoc false

  use Phoenix.Component
  use KotkowoWeb, :verified_routes

  import KotkowoWeb.Components.Cards
  import KotkowoWeb.Components.Sections
  import KotkowoWeb.Gettext

  attr :fold, :boolean,
    default: true,
    doc: "Whether should fold into horizontaly scrollable"

  slot :inner_block, required: true

  defp container(assigns) do
    ~H"""
    <%= if @fold do %>
      <div class="flex w-full px-2">
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

  def help_cards do
    [
      %{
        src: ~p"/images/heart_lend.png",
        alt: gettext("Heart lending"),
        text: gettext("Przekaż nam 1,5% podatku"),
        href: ~p"/pomoc/przekaz-nam-podatek"
      },
      %{
        src: ~p"/images/piggy_bank.png",
        alt: gettext("Piggy bank"),
        text: gettext("Wesprzyj nas finansowo"),
        href: ~p"/pomoc/wsparcie-finansowe"
      },
      %{
        src: ~p"/images/spices.png",
        alt: gettext("Food"),
        text: gettext("Przekaż rzeczy dla kotków"),
        href: ~p"/pomoc/przekaz-rzeczy-dla-kotkow"
      },
      %{
        src: ~p"/images/cat_on_couch.png",
        alt: gettext("Cat on couch"),
        text: gettext("Stwórz dom tymczasowy"),
        href: ~p"/pomoc/stworz-dom-tymczasowy"
      },
      %{
        src: ~p"/images/cat_food.png",
        alt: gettext("Cat food"),
        text: gettext("Zorganizuj zbiórkę"),
        href: ~p"/pomoc/zorganizuj-zbiorke-rzeczowa"
      }
    ]
  end

  def path_from_meta(meta) do
    routes = KotkowoWeb.Router.__routes__()

    current_route =
      Enum.find(routes, %{path: "#"}, fn route ->
        route.plug == meta.controller && route.plug_opts == meta.method
      end)

    current_route.path
  end

  def help_cards_without_current(meta) do
    cards = help_cards()
    current_path = path_from_meta(meta)
    current = Enum.find(cards, fn %{href: href} -> href == current_path end)

    List.delete(cards, current)
  end

  attr :fold, :boolean,
    default: true,
    doc: "Whether should fold into horizontaly scrollable"

  attr :meta, :any, default: nil, doc: "Page metadata used to adapt links"

  def how_you_can_help(assigns) do
    ~H"""
    <.section>
      <h1 class="text-primary mb-8 font-manrope font-extrabold xl:text-4xl text-2xl text-center">
        Jak możesz pomóc?
      </h1>

      <.container fold={@fold}>
        <%= for card <- help_cards() do %>
          <.help_card href={card.href} src={card.src} alt={card.alt}>
            <%= card.text %>
          </.help_card>
        <% end %>
      </.container>
    </.section>
    """
  end
end
