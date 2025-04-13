defmodule KotkowoWeb.LiveComponents.CatFilter do
  @moduledoc false
  use Phoenix.LiveComponent

  import KotkowoWeb.Components.Buttons
  import KotkowoWeb.Components.Drawers

  alias Kotkowo.Client.Cat
  alias Kotkowo.Client.Cat.Age
  alias Kotkowo.Client.Cat.Color
  alias Kotkowo.Client.Cat.Sex

  @fields [:name, :tag, :sex, :castrated, :age, :dates, :color, :chip]
  @default_fields [:name, :tag, :sex, :castrated, :age, :color]

  @impl true
  def mount(socket) do
    socket =
      assign(socket, :raw_filter, Map.from_struct(%Cat.Filter{}))

    {:ok, socket}
  end

  @impl true
  def update(assigns, socket) do
    socket =
      if assigns[:initial_filter] do
        filter =
          assigns[:initial_filter]
          |> Map.from_struct()
          |> Map.new(fn
            {k, {_, v}} -> {k, v}
            {k, v} -> {k, v}
          end)

        assign(socket, :raw_filter, filter)
      else
        socket
      end

    assign_fields = Map.filter(assigns, fn {key, _val} -> key in @fields end)
    included_fields = Enum.filter(@fields, fn field -> Map.get(assign_fields, field, field in @default_fields) end)

    socket =
      socket
      |> assign(:included_fields, included_fields)
      |> assign(:search_name, Map.get(assigns, :search_name, :filter_cat))

    {:ok, socket}
  end

  @string_ages Enum.map(Cat.Age.all(), &to_string/1)
  @string_colors Enum.map(Cat.Color.all(), &to_string/1)

  @impl true
  def handle_event("change", params, socket)
      when is_map(params) and
             (is_map_key(params, "chip_search") or is_map_key(params, "cat_search") or is_map_key(params, "tag_search")) do
    raw_filter =
      socket.assigns.raw_filter
      |> put_if_exists(params, "cat_search", :name, & &1)
      |> put_if_exists(params, "chip_search", :chip_number, & &1)
      |> put_if_exists(params, "tag_search", :tags, &String.split/1)

    filter = Cat.Filter.from_map(raw_filter)

    socket = assign(socket, :raw_filter, raw_filter)

    send(self(), {socket.assigns.search_name, filter})

    {:noreply, socket}
  end

  def handle_event("change", params, socket)
      when is_map(params) and (is_map_key(params, "age") or is_map_key(params, "color")) do
    raw_filter =
      socket.assigns.raw_filter
      |> put_if_exists(params, "age", :age, fn age ->
        age |> Enum.filter(&(&1 in @string_ages)) |> Enum.map(&String.to_existing_atom/1)
      end)
      |> put_if_exists(params, "color", :color, fn color ->
        color |> Enum.filter(&(&1 in @string_colors)) |> Enum.map(&String.to_existing_atom/1)
      end)

    filter = Cat.Filter.from_map(raw_filter)

    socket = assign(socket, :raw_filter, raw_filter)

    send(self(), {socket.assigns.search_name, filter})

    {:noreply, socket}
  end

  def handle_event("change", %{"sex" => sex}, socket) do
    sex = if sex != "", do: String.to_existing_atom(sex)

    raw_filter = %{socket.assigns.raw_filter | sex: sex}
    filter = Cat.Filter.from_map(raw_filter)

    socket = assign(socket, :raw_filter, raw_filter)

    send(self(), {socket.assigns.search_name, filter})

    {:noreply, socket}
  end

  def handle_event("change", %{"castrated" => castrated}, socket) do
    raw_filter = %{socket.assigns.raw_filter | castrated: if(castrated != "", do: castrated == "on")}
    filter = Cat.Filter.from_map(raw_filter)

    socket = assign(socket, :raw_filter, raw_filter)

    send(self(), {socket.assigns.search_name, filter})

    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.drawer
        title="Filtruj według"
        allow_unfolded={true}
        title_class="text-primary text-justify font-manrope text-2xl font-bold"
        class="xl:w-full block xl:hidden"
      >
        <div class="p-6 flex flex-col space-y-6 h-min">
          <form phx-change="change" phx-target={@myself} class="flex flex-col space-y-6 h-min">
            <h4 class="lg:block hidden text-primary text-justify font-manrope text-2xl font-bold">
              Filtruj według
            </h4>
            <div :if={:name in @included_fields} class="flex flex-col space-y-4">
              <h3 class="font-bold text-primary text-sm">Imię</h3>
              <input
                phx-debounce={100}
                name="cat_search"
                type="text"
                placeholder="Wpisz imię kota"
                class="border border-gray rounded-lg text-sm"
                value={@raw_filter.name}
              />
            </div>

            <div :if={:chip in @included_fields} class="flex flex-col space-y-4">
              <h3 class="font-bold text-primary text-sm">Nr. chipa</h3>
              <input
                phx-debounce={100}
                name="chip_search"
                type="text"
                placeholder="Wpisz numer chipa"
                class="border border-gray rounded-lg text-sm"
                value={@raw_filter.chip_number}
              />
            </div>

            <div :if={:tag in @included_fields} class="flex flex-col space-y-4">
              <h3 class="font-bold text-primary text-sm">Tagi</h3>
              <input
                type="text"
                name="tag_search"
                phx-debounce="100"
                id={"#{@search_name}-tagSearch"}
                placeholder="Wpisz cechę kota"
                class="border border-gray rounded-lg text-sm"
                value={if @raw_filter.tags, do: Enum.join(@raw_filter.tags, " "), else: ""}
              />
            </div>
          </form>

          <div :if={:sex in @included_fields} class="flex flex-col space-y-6 h-min">
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
                {Sex.to_string(:male)}
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
                {Sex.to_string(:female)}
              </label>
            </form>
          </div>

          <form phx-change="change" phx-target={@myself} class="flex flex-col space-y-6 h-min">
            <.checkgroup
              :if={:age in @included_fields}
              id={"#{@search_name}-age-checkgroup"}
              name="age"
              label="Wiek"
              options={Enum.map(Age.all(), fn age -> {Age.to_string(age), age} end)}
              value={@raw_filter.age || []}
            />

            <.checkgroup
              :if={:color in @included_fields}
              id={"#{@search_name}-color-checkgroup"}
              name="color"
              label="Kolor"
              options={Enum.map(Color.all(), fn color -> {Color.to_string(color), color} end)}
              value={@raw_filter.color || []}
            />
          </form>

          <div :if={:castrated in @included_fields} class="flex flex-col space-y-6 h-min">
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
            <form :if={:dates in @included_fields} phx-target={@myself} phx-change="change">
              meow
            </form>
          </div>
        </div>
      </.drawer>
    </div>
    """
  end

  defp put_if_exists(map, params, key, new_key, transform) when is_map_key(params, key) do
    if to_charlist(params[key]) != [],
      do: Map.put(map, new_key, transform.(params[key])),
      else: Map.put(map, new_key, nil)
  end

  defp put_if_exists(map, _params, _key, _new_key, _transform), do: map
end
