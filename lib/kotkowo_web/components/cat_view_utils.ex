defmodule KotkowoWeb.Components.CatViewUtils do
  @moduledoc false
  use Phoenix.Component

  import KotkowoWeb.Components.Buttons
  import KotkowoWeb.Components.Cards
  import KotkowoWeb.Components.Icons
  import KotkowoWeb.WebHelpers
  import Tails

  alias Kotkowo.Client.Cat
  alias Phoenix.LiveView.JS

  def thumbnails(images, index) do
    images
    |> Enum.with_index()
    |> List.pop_at(index)
    |> elem(1)
  end

  attr :caretaker, :any, default: false
  slot :subtitle
  attr :heading, :string, required: true
  attr :contact_informations, :map, required: true

  def contact(assigns) do
    ~H"""
    <div class="flex flex-col gap-y-4 px-4 xl:px-0 xl:mt-0 mt-4">
      <h2 class="font-manrope font-bold text-xl xl:text-2xl">
        <%= @heading %>
      </h2>
      <%= render_slot(@subtitle) %>
      <div :if={@caretaker != false}>
        <p :if={!@caretaker} class="xl:text-lg">
          Kotem opiekuje się <b>Nikt</b>
        </p>
        <p :if={@caretaker} class="xl:text-lg">
          Kotem opiekuje się <b><%= @caretaker.first_name %></b>
        </p>
      </div>
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
        <span :if={@contact_informations == []} class="font-semibold">
          Brak informacji kontaktowych
        </span>
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

  @cat_info_fields [:sex, :age, :medical_status, :castrated, :healthy, :fiv_felv, :tag]
  attr :cat_fields, :list, default: @cat_info_fields
  attr :cat, :any, required: true
  attr :share_href, :string, default: nil
  slot :extra_field
  attr :class, :string, default: ""
  attr :header, :boolean, default: true

  def cat_info(assigns) do
    ~H"""
    <div class="flex flex-col space-y-6 xl:px-0 px-4 xl:mt-0 mt-4">
      <h2 :if={@header} class="font-manrope font-bold xl:font-extrabold text-xl xl:text-3xl">
        Informacje o kocie
      </h2>

      <ul class={
        classes([
          "flex flex-col gap-y-4 font-bold font-manrope xl:text-xl 2xl:whitespace-nowrap",
          @class
        ])
      }>
        <%= for field <- @extra_field do %>
          <%= render_slot(field) %>
        <% end %>
        <li :if={:sex in @cat_fields && @cat.sex} class="flex align-center gap-x-4">
          <.icon name="gender" class="w-5" /><%= Cat.Sex.to_string(@cat.sex) %>
        </li>
        <li :if={:age in @cat_fields && @cat.age} class="flex align-center gap-x-4">
          <.icon name="paw" class="w-5" /><%= Cat.Age.to_string(@cat.age) %>
        </li>
        <li
          :if={:medical_status in @cat_fields && @cat.medical_status}
          class="flex align-center gap-x-4"
        >
          <.icon name="sthetoscope" class="w-5" />
          <%= Cat.MedicalStatus.to_string(@cat.medical_status) %>
        </li>
        <li :if={:castrated in @cat_fields && @cat.castrated} class="flex align-center gap-x-4">
          <.icon name="scissors" class="w-5" />
          <%= Cat.Castrated.to_string(@cat.castrated) %>
        </li>
        <li :if={:healthy in @cat_fields && @cat.healthy} class="flex align-center gap-x-4">
          <.icon name="ekg" class="w-5" />
          <%= Cat.Healthy.to_string(@cat.healthy) %>
        </li>
        <li :if={:fiv_felv in @cat_fields && @cat.fiv_felv} class="flex align-center gap-x-4">
          <.icon name="medicine" class="w-3 mx-1" />
          <%= Cat.FivFelv.to_string(@cat.fiv_felv) %>
        </li>
      </ul>

      <div :if={:tag in @cat_fields} class="flex flex-row flex-wrap gap-x-2 gap-y-8">
        <%= for text <- @cat.tags do %>
          <div class="w-auto h-auto">
            <.card_tag><%= text %></.card_tag>
          </div>
        <% end %>
      </div>
      <div
        :if={@share_href}
        phx-click={JS.dispatch("share_modal")}
        share_href={@share_href}
        share_quote={@cat.description_heading}
        class="py-3 select-none bg-primary text-white hover:text-white hover:bg-primary-lighter px-6 xl:px-10 rounded-full text-center xl:text-lg font-medium w-max transition-colors ease-in-out duration-150"
      >
        Udostępnij znajomym
      </div>
    </div>
    """
  end
end
