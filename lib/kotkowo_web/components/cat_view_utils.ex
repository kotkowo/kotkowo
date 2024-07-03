defmodule KotkowoWeb.Components.CatViewUtils do
  @moduledoc false
  use Phoenix.Component

  import KotkowoWeb.Components.Buttons
  import KotkowoWeb.Components.Cards
  import KotkowoWeb.Components.Icons
  import KotkowoWeb.Constants
  import KotkowoWeb.WebHelpers

  alias Kotkowo.Client.Cat
  alias Phoenix.LiveView.JS

  def thumbnails(images, index) do
    images
    |> Enum.with_index()
    |> List.pop_at(index)
    |> elem(1)
  end

  def contact(assigns) do
    ~H"""
    <div class="flex flex-col gap-y-4 px-4 xl:px-0 xl:mt-0 mt-4">
      <h2 class="font-manrope font-bold text-xl xl:text-2xl">Interesuje Cię adopcja?</h2>
      <p class="xl:text-lg">
        Wypełnij
        <a href={adoption_form()} class="text-primary font-bold underline underline-offset-4">
          ankietę adopcyjną
        </a>
      </p>
      <p :if={!@caretaker} class="xl:text-lg">
        Kotem opiekuje się <b>Nikt</b>
      </p>
      <p :if={@caretaker} class="xl:text-lg">
        Kotem opiekuje się <b><%= @caretaker.first_name %></b>
      </p>
      <h4 class="text-primary font-bold xl:text-lg">Telefon do opiekuna</h4>
      <div class="flex space-x-2">
        <.button
          :if={@caretaker}
          href={"tel:#{@caretaker.phone_number}"}
          type="outline"
          class="
          !px-4 !py-1.5 text-black font-normal xl:text-sm flex gap-x-1.5 align-center"
        >
          <.icon name="telephone" />

          <span class="w-full">
            <%= beautify_phone_number(@caretaker.phone_number) %>
          </span>
        </.button>
        <%= for contact_info <- @contact_informations do %>
          <.button
            href={"tel:#{contact_info.phone_number}"}
            type="outline"
            class="!px-4 !py-1.5 text-black font-normal xl:text-sm flex gap-x-1.5 align-center"
          >
            <.icon name="telephone" />
            <span class="w-full">
              <%= beautify_phone_number(contact_info.phone_number) %>
            </span>
          </.button>
        <% end %>
      </div>
    </div>
    """
  end

  def cat_info(assigns) do
    ~H"""
    <div class="flex flex-col space-y-6 xl:px-0 px-4 xl:mt-0 mt-4">
      <h2 class="font-manrope font-bold xl:font-extrabold text-xl xl:text-3xl">Informacje o kocie</h2>

      <ul class="flex flex-col gap-y-4 font-bold font-manrope xl:text-xl 2xl:whitespace-nowrap">
        <li class="flex align-center gap-x-4">
          <.icon name="gender" class="w-5" /><%= Cat.Sex.to_string(@cat.sex) %>
        </li>
        <li class="flex align-center gap-x-4">
          <.icon name="paw" class="w-5" /><%= Cat.Age.to_string(@cat.age) %>
        </li>
        <li class="flex align-center gap-x-4">
          <.icon name="sthetoscope" class="w-5" />
          <%= Cat.MedicalStatus.to_string(@cat.medical_status) %>
        </li>
        <li class="flex align-center gap-x-4">
          <.icon name="scissors" class="w-5" />
          <%= Cat.Castrated.to_string(@cat.castrated) %>
        </li>
        <li class="flex align-center gap-x-4">
          <.icon name="ekg" class="w-5" />
          <%= Cat.Healthy.to_string(@cat.healthy) %>
        </li>
        <li class="flex align-center gap-x-4">
          <.icon name="medicine" class="w-3 mx-1" />
          <%= Cat.FivFelv.to_string(@cat.fiv_felv) %>
        </li>
      </ul>

      <div class="flex flex-row flex-wrap gap-x-2 gap-y-8">
        <%= for text <- @cat.tags do %>
          <div class="w-auto h-auto">
            <.card_tag><%= text %></.card_tag>
          </div>
        <% end %>
      </div>
      <div
        phx-click={JS.dispatch("share_modal")}
        share_href={"#{kotkowo_url()}/adopcja/szukaja-domu/#{@cat.slug}"}
        share_quote={@cat.description_heading}
        class="py-3 select-none bg-primary text-white hover:text-white hover:bg-primary-lighter px-6 xl:px-10 rounded-full text-center xl:text-lg font-medium w-max transition-colors ease-in-out duration-150"
      >
        Udostępnij znajomym
      </div>
    </div>
    """
  end
end
