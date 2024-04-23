defmodule KotkowoWeb.LostAndFoundLive.LostLive.Show do
  @moduledoc false
  use KotkowoWeb, :live_view

  import KotkowoWeb.Components.Static.HowYouCanHelpSection
  import KotkowoWeb.WebHelpers, only: [beautify_phone_number: 1]

  def mount(%{"slug" => slug}, _session, socket) do
    lost_cat = %{
      title:
        "Placeholder cat Lorem ipsum dolor sit amet, qui minim labore adipisicing minim sint cillum sint consectetur cupidatatlore.",
      sex: "Male",
      disappearance_date: "21-01-2024",
      disappearance_location: "ul. Orzeszkowej",
      chip_number: "123456789123456",
      during_treatment: false,
      name: "Mruczek",
      color: "Blue",
      special_signs: "none",
      disappearance_circumstances:
        "Bury przyjazny kocurek błąkał się po Dojlidach w pobliżu plaży. Nie boi do ludzi, chętnie podchodzi i domaga się głaskania. Widać, że miał dom. Ma chipa, jednak nie jest zarejestrowany w bazie. Jeśli ktoś go kojarzy, bardzo prosimy o informację.",
      phone_numbers: ["+48123456789", "123456789"]
    }

    socket =
      socket
      |> assign(:slug, slug)
      |> assign(:lost_cat, lost_cat)

    {:ok, socket}
  end

  defp cat_info(assigns) do
    ~H"""
    <div class="flex px-6 flex-col gap-y-4">
      <h2 class="font-manrope tracking-wide font-bold text-xl lg:text-2xl">Informacje o kocie</h2>
      <div class="flex flex-col gap-y-2">
        <div class="flex flex-row gap-x-2">
          <.icon name="location" class="w-3 text-center" />
          <span class="font-inter text-primary font-bold">Miejsce zaginięcia</span>
        </div>
        <div class="flex-row flex gap-x-2">
          <div class="border-gray border rounded-3xl text-sm px-3 py-2">
            <%= @lost_cat.disappearance_location %>
          </div>
        </div>
      </div>
      <ul class="flex flex-col gap-y-4 font-bold font-manrope 2xl:whitespace-nowrap">
        <li class="flex flex-row">
          <div class="flex w-8 justify-center mr-2">
            <.icon name="barcode" class="w-6 text-center" />
          </div>

          <span>Nr. chipa: <%= to_string(@lost_cat.chip_number) %></span>
        </li>
        <li class=" flex flex-row">
          <div class="flex w-8 justify-center mr-2">
            <.icon name="barcode" class="w-6 text-center" />
          </div>

          <span>Kolor: <%= to_string(@lost_cat.color) %></span>
        </li>
        <li class=" flex flex-row">
          <div class="flex w-8 justify-center mr-2">
            <.icon name="gender" class="w-5 text-center" />
          </div>

          <span>Płeć: <%= to_string(@lost_cat.sex) %></span>
        </li>
        <li class=" flex flex-row">
          <div class="flex w-8 justify-center mr-2">
            <.icon name="star" class="w-7 text-center" />
          </div>

          <span>Znaki szczególne: <%= to_string(@lost_cat.special_signs) %></span>
        </li>
        <li class=" flex flex-row">
          <div class="flex w-8 justify-center mr-2">
            <.icon name="medicine" class="w-4 text-center" />
          </div>

          <span>W trakcie leczenia: <%= to_string(@lost_cat.during_treatment) %></span>
        </li>
        <li class="flex flex-row">
          <div class="flex w-8 justify-center mr-2">
            <.icon name="calendar" class="w-6 text-center" />
          </div>

          <span>Data zaginięcia: <%= to_string(@lost_cat.disappearance_date) %></span>
        </li>
        <li class="flex flex-row">
          <div class="flex w-8 justify-center mr-2">
            <.icon name="nametag" class="w-6 text-center" />
          </div>
          <span>Imię: <%= to_string(@lost_cat.name) %></span>
        </li>
      </ul>

      <.button href="#" class="mt-4">Udostępnij znajomym</.button>
    </div>
    """
  end

  defp phone_numbers(assigns) do
    ~H"""
    <div class="flex flex-col gap-y-2">
      <span class="text-primary font-bold">Telefon</span>
      <div class="flex flex-row gap-x-2">
        <div
          :for={phone_number <- @lost_cat.phone_numbers}
          class="rounded-3xl border lg:border-2 border-primary p-2 lg:py-2 lg:px-3"
        >
          <a class="flex flex-row" href={"tel:+48#{phone_number}"}>
            <Heroicons.phone solid class="w-4 text-primary lg:mr-1" />
            <span class="font-inter text-xs lg:text-sm tracking-tighter lg:tracking-tight">
              <%= phone_number |> beautify_phone_number() %>
            </span>
          </a>
        </div>
      </div>
    </div>
    """
  end
end
