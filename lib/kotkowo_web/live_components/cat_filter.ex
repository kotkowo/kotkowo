defmodule KotkowoWeb.LiveComponents.CatFilter do
  @moduledoc false
  use Phoenix.LiveComponent

  import KotkowoWeb.Components.Buttons
  import KotkowoWeb.Components.Drawers

  alias Kotkowo.Client.Cat
  alias Kotkowo.Client.Cat.Age
  alias Kotkowo.Client.Cat.Color
  alias Kotkowo.Client.Cat.Sex

  def mount(socket) do
    socket =
      assign(socket, :raw_filter, Map.from_struct(%Cat.Filter{}))

    {:ok, socket}
  end

  @string_ages Enum.map(Cat.Age.all(), &to_string/1)
  @string_colors Enum.map(Cat.Color.all(), &to_string/1)

  def handle_event("change", %{"cat_search" => cat_search, "tag_search" => tag_search}, socket) do
    cat_search = unless(cat_search == "", do: cat_search)
    tag_search = unless(tag_search == "", do: String.split(tag_search))

    raw_filter = %{
      socket.assigns.raw_filter
      | name: cat_search,
        tags: tag_search
    }

    filter = Cat.Filter.from_map(raw_filter)

    socket = assign(socket, :raw_filter, raw_filter)

    send(self(), {:filter_cat, filter})

    {:noreply, socket}
  end

  def handle_event("change", %{"age" => age, "color" => color}, socket) do
    age = age |> Enum.filter(&(&1 in @string_ages)) |> Enum.map(&String.to_existing_atom/1)
    color = color |> Enum.filter(&(&1 in @string_colors)) |> Enum.map(&String.to_existing_atom/1)

    raw_filter = %{
      socket.assigns.raw_filter
      | age: unless(Enum.empty?(age), do: age),
        color: unless(Enum.empty?(color), do: color)
    }

    filter = Cat.Filter.from_map(raw_filter)

    socket = assign(socket, :raw_filter, raw_filter)

    send(self(), {:filter_cat, filter})

    {:noreply, socket}
  end

  def handle_event("change", %{"sex" => sex}, socket) do
    sex = if sex != "", do: String.to_existing_atom(sex)

    raw_filter = %{socket.assigns.raw_filter | sex: sex}
    filter = Cat.Filter.from_map(raw_filter)

    socket = assign(socket, :raw_filter, raw_filter)

    send(self(), {:filter_cat, filter})

    {:noreply, socket}
  end

  def handle_event("change", %{"castrated" => castrated}, socket) do
    raw_filter = %{socket.assigns.raw_filter | castrated: if(castrated != "", do: castrated == "on")}
    filter = Cat.Filter.from_map(raw_filter)

    socket = assign(socket, :raw_filter, raw_filter)

    send(self(), {:filter_cat, filter})

    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <div>
      <.drawer
        class_when_hidden="hidden lg:block"
        title="Filtruj według"
        title_class="text-primary text-justify font-manrope text-2xl font-bold"
        class="xl:w-full block lg:hidden"
      >
        <div class="p-6 flex flex-col space-y-6 h-min">
          <form phx-change="change" phx-target={@myself} class="flex flex-col space-y-6 h-min">
            <h4 class="lg:block hidden text-primary text-justify font-manrope text-2xl font-bold">
              Filtruj według
            </h4>
            <div class="flex flex-col space-y-4">
              <h3 class="font-bold text-primary text-sm">Imię</h3>
              <input
                phx-debounce
                name="cat_search"
                type="text"
                placeholder="Wpisz imię kota"
                class="border border-gray rounded-lg text-sm"
              />
            </div>

            <div class="flex flex-col space-y-4">
              <h3 class="font-bold text-primary text-sm">Tagi</h3>
              <input
                type="text"
                name="tag_search"
                phx-debounce="100"
                id="tagSearch"
                placeholder="Wpisz cechę kota"
                class="border border-gray rounded-lg text-sm"
              />
            </div>
          </form>

          <div class="flex flex-col space-y-6 h-min">
            <h3 class="font-bold text-primary text-sm">Płeć</h3>
            <form phx-target={@myself} phx-change="change">
              <input type="hidden" name="sex" value="" />
              <label class="text-sm">
                <input
                  type="checkbox"
                  name="sex"
                  class="mr-3.5 border-gray rounded"
                  value="male"
                  checked={@raw_filter.sex != nil and :male == @raw_filter.sex}
                />
                <%= Sex.to_string(:male) %>
              </label>
            </form>

            <form phx-target={@myself} phx-change="change">
              <input type="hidden" name="sex" value="" />
              <label class="text-sm">
                <input
                  type="checkbox"
                  name="sex"
                  class="mr-3.5 border-gray rounded"
                  value="female"
                  checked={@raw_filter.sex != nil and :female == @raw_filter.sex}
                />
                <%= Sex.to_string(:female) %>
              </label>
            </form>
          </div>

          <form phx-change="change" phx-target={@myself} class="flex flex-col space-y-6 h-min">
            <.checkgroup
              id="age-checkgroup"
              name="age"
              label="Wiek"
              options={Enum.map(Age.all(), fn age -> {Age.to_string(age), age} end)}
              value={@raw_filter.age || []}
            />

            <.checkgroup
              id="color-checkgroup"
              name="color"
              label="Kolor"
              options={Enum.map(Color.all(), fn color -> {Color.to_string(color), color} end)}
              value={@raw_filter.color || []}
            />
          </form>

          <div class="flex flex-col space-y-6 h-min">
            <h3 class="font-bold text-primary text-sm">Kastracja / sterylizacja</h3>
            <form phx-target={@myself} phx-change="change">
              <input type="hidden" name="castrated" value="" />
              <label class="text-sm">
                <input
                  type="checkbox"
                  name="castrated"
                  class="mr-3.5 border-gray rounded"
                  value="on"
                  checked={@raw_filter.castrated != nil and @raw_filter.castrated}
                /> po zabiegu
              </label>
            </form>

            <form phx-target={@myself} phx-change="change">
              <input type="hidden" name="castrated" value="" />
              <label class="text-sm">
                <input
                  type="checkbox"
                  name="castrated"
                  class="mr-3.5 border-gray rounded"
                  value="off"
                  checked={@raw_filter.castrated != nil and !@raw_filter.castrated}
                /> przed zabiegiem
              </label>
            </form>
          </div>
        </div>
      </.drawer>
    </div>
    """
  end
end
