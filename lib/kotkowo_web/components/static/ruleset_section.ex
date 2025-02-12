defmodule KotkowoWeb.Components.Static.RulesetSection do
  @moduledoc false

  use Phoenix.Component
  use KotkowoWeb, :verified_routes

  import KotkowoWeb.Components.Buttons
  import KotkowoWeb.Constants
  import Tails

  attr :header_class, :string, default: ""
  attr :body_class, :string, default: ""

  def ruleset_section(assigns) do
    ~H"""
    <div class="flex flex-col gap-y-12 lg:gap-y-16 items-center lg:gap-y-0 lg:flex-row justify-between">
      <div class="flex flex-col lg:w-[646px] gap-y-6">
        <h1 class={
          classes([
            "text-primary font-manrope font-bold lg:font-extrabold text-3xl lg:text-6xl",
            @header_class
          ])
        }>
          Zasady kotkowa
        </h1>
        <div class={
          classes(["text-lg space-y-1 flex flex-wrap lg:tracking-wide font-inter", @body_class])
        }>
          <p>
            1. Nie handlujemy zwierzętami. Nie sprzedajemy kotów ani ich nie kupujemy.
          </p>
          <p>
            2. Pomagamy przede wszystkim kotom bezdomnym, wolno żyjącym w Białymstoku lub najbliższych okolicach.
          </p>
          <p>
            3. Nie przyjmujemy do Domów Tymczasowych potomstwa kotek, które zostały rozmnożone w domu.
          </p>
          <p>
            4. Nie finansujemy nieodpowiedzialności. Warunkiem pomocy w adopcji kociaków jest zawsze sterylizacja kociej mamy.
          </p>
          <p>
            5. Jeżeli pośredniczymy w adopcjach kotków — wymagamy podpisania umowy adopcyjnej z zobowiązaniem do sterylizacji/kastracji zwierzaczka - wzór umowy adopcyjnej.
          </p>
          <p>
            6. Nie wysyłamy kotów pocztą, kurierem itp. Jeżeli chcesz przygarnąć kotka — musimy spotkać się osobiście.
          </p>
          <p>
            7. Chcemy pomóc, ale czasem mamy też swoje sprawy. Dlatego czasem ciężko się do nas dodzwonić, a zdarza się, że na maila odpowiadamy późno wieczorem lub następnego dnia.
          </p>
          <p>
            8. Nasza działalność jest transparentna. Zawsze możesz zajrzeć do dokumentacji kotkowa.
          </p>
        </div>
        <div class="flex flex-col gap-y-4">
          <.button navigate={~p"/adopcja/szukaja-domu"}>Zobacz koty do adopcji</.button>

          <.button href={adoption_form()} target="_blank" type="outline">
            Wypełnij ankietę adopcyjną
          </.button>
        </div>
      </div>
      <img
        src={~p"/images/adoption_rules_kitty.jpg"}
        alt="kot na drewnianej podłodze"
        class="object-cover items-center w-[312px] -mt-6 lg:w-[536px] h-[363px] lg:h-[688px] rounded-2xl"
      />
    </div>
    """
  end
end
