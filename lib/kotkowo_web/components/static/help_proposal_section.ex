defmodule KotkowoWeb.Components.Static.HelpProposalSection do
  @moduledoc false

  use Phoenix.Component
  use KotkowoWeb, :verified_routes

  import KotkowoWeb.Components.Buttons
  import KotkowoWeb.Components.Icons
  import KotkowoWeb.Components.Sections
  import KotkowoWeb.Constants

  attr :parent_class, :any, default: nil
  attr :class, :any, default: nil

  def help_proposal_section(assigns) do
    ~H"""
    <.section
      class={["flex flex-col xl:flex-row px-6 xl:px-0 lg:justify-between", @class]}
      parent_class={@parent_class}
    >
      <div class="flex flex-col space-y-6">
        <h2 class="fonx-bold xl:font-extrabold font-manrope text-xl xl:text-2xl text-primary">
          Zaproponuj własną formę wsparcia
        </h2>

        <p class="text-base xl:text-lg max-w-[535px] tracking-wide">
          Jeżeli możesz pomóc nam w inny sposób, np. moderując Instagrama, zamieszczając filmiki na TikToku lub robiąc zdjęcia kotów – daj nam znać.
          Napisz do nas lub wypełnij formularz dla wolontariuszy, a my skontaktujemy się z Tobą, jak tylko będzie to możliwe.
        </p>

        <a href={"mailto:#{kotkowo_mail()}"} class="flex">
          <.icon name="envelope2" class="w-6 h-6 my-auto mr-2 inline invert" />
          <span class="underline">
            <%= kotkowo_mail() %>
          </span>
        </a>

        <a href={kotkowo_facebook()} target="_blank" rel="noopener noreferrer" class="flex">
          <.icon name="facebook_outline" class="w-6 h-6 my-auto mr-2 inline" />
          <span class="underline">
            facebook.com/kotkowo
          </span>
        </a>

        <.button
          type="outline"
          target="_blank"
          rel="noopener noreferrer"
          href={volunteer_form()}
          class="!px-6"
        >
          Zostań wolontariuszem
        </.button>
      </div>

      <img
        src={~p"/images/help_proposal_kitty.jpeg"}
        class="rounded-2xl w-[312px] h-[212px] lg:w-[531px] lg:h-[354px] mt-6 lg:mt-0"
        alt="Kot lężacy na plecach"
        class="self-center"
      />
    </.section>
    """
  end
end
