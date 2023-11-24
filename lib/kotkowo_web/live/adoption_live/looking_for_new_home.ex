defmodule KotkowoWeb.AdoptionLive.LookingForNewHome do
  @moduledoc false
  use KotkowoWeb, :live_view

  import KotkowoWeb.Components.Drawers
  import KotkowoWeb.Components.Static.HowYouCanHelpSection

  alias Kotkowo.Attributes.Color
  alias Kotkowo.Attributes.Seniority
  alias Kotkowo.Attributes.Sex
  alias Kotkowo.GalleryImage
  alias Kotkowo.StrapiClient

  @first_page 1
  @default_limit 30
  @impl true
  def mount(_params, _session, socket) do
    {:ok, cats} = StrapiClient.list_cats(false, false)

    socket =
      assign(socket, :cats, cats)

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    limit = params |> Map.get("limit", Integer.to_string(@default_limit)) |> String.to_integer() |> abs()
    page = params |> Map.get("page", Integer.to_string(@first_page)) |> String.to_integer()

    name = params |> Map.get("name", "") |> String.downcase()
    ages = Map.get(params, "ages", [])
    genders = Map.get(params, "genders", [])
    castrated = params |> Map.get("castrated", nil) |> query_to_bool()
    tag = params |> Map.get("tag", "") |> String.downcase()
    colors = Map.get(params, "colors", [])
    date_to = Map.get(params, "date_to", "")
    date_from = Map.get(params, "date_from", "")

    filtered_cats =
      socket.assigns.cats
      |> search_tags(tag)
      |> search_names(name)
      |> filter_castrated(castrated)
      |> filter_ages(ages)
      |> filter_genders(genders)
      |> filter_colors(colors)
      |> filter_dates(date_from, date_to)

    max_page = max(@first_page, ceil(length(filtered_cats) / limit))

    page =
      cond do
        page < @first_page -> @first_page
        page > max_page -> max_page
        true -> page
      end

    offset = (page - 1) * limit

    socket =
      socket
      |> assign(:tag, tag)
      |> assign(:name, name)
      |> assign(:castrated, castrated)
      |> assign(:ages, ages)
      |> assign(:genders, genders)
      |> assign(:date_from, date_from)
      |> assign(:colors, colors)
      |> assign(:date_to, date_to)
      |> assign(:limit, limit)
      |> assign(:page, page)
      |> assign(:filtered_cats, Enum.slice(filtered_cats, offset, limit))
      |> assign(:max_page, max_page)

    {:noreply, socket}
  end

  @impl true
  def handle_event(
        "filter_cats",
        %{
          "_target" => event,
          "date_from" => date_from,
          "date_to" => date_to,
          "cat_search" => name_query,
          "tag_search" => tag_query
        } = params,
        socket
      ) do
    limit = socket.assigns |> Map.get(:limit, Integer.to_string(@default_limit)) |> abs()
    page = Map.get(socket.assigns, :page, Integer.to_string(@first_page))

    not_castrated = params |> Map.get("not_castrated", nil) |> query_to_bool()

    is_castrated =
      params
      |> Map.get("is_castrated", nil)
      |> query_to_bool()
      |> castrated_switch(not_castrated, event)

    ages =
      for key <- Seniority.all(),
          true == params |> Map.get(Atom.to_string(key), false) |> query_to_bool(),
          do: key

    genders =
      for key <- Sex.all(),
          true == params |> Map.get(Atom.to_string(key), false) |> query_to_bool(),
          do: key

    colors =
      for key <- Color.all(),
          true == params |> Map.get(Atom.to_string(key), false) |> query_to_bool(),
          do: key

    query_params = %{
      name: name_query,
      tag: tag_query,
      castrated: is_castrated,
      ages: ages,
      genders: genders,
      date_from: date_from,
      colors: colors,
      date_to: date_to,
      page: page,
      limit: limit
    }

    socket =
      push_patch(socket, to: ~p"/adopcja/szukaja-domu?#{query_params}")

    {:noreply, socket}
  end

  @impl true
  def handle_event("items_amount", %{"items_per_page" => amount}, socket) do
    limit = amount |> String.to_integer() |> abs()
    max_page = max(@first_page, socket.assigns.filtered_cats |> length() |> div(limit))

    query_params = %{
      name: socket.assigns.name,
      tag: socket.assigns.tag,
      castrated: socket.assigns.castrated,
      ages: socket.assigns.ages,
      colors: socket.assigns.colors,
      genders: socket.assigns.genders,
      date_from: socket.assigns.date_from,
      date_to: socket.assigns.date_to,
      page: socket.assigns.page,
      limit: limit
    }

    socket =
      socket
      |> assign(:max_page, max_page)
      |> push_patch(to: ~p"/adopcja/szukaja-domu?#{query_params}")

    {:noreply, socket}
  end

  @impl true
  def handle_event("select_page", %{"value" => page}, socket) do
    query_params = %{
      name: socket.assigns.name,
      tag: socket.assigns.tag,
      castrated: socket.assigns.castrated,
      ages: socket.assigns.ages,
      genders: socket.assigns.genders,
      date_from: socket.assigns.date_from,
      colors: socket.assigns.colors,
      date_to: socket.assigns.date_to,
      page: page,
      limit: socket.assigns.limit
    }

    socket = push_patch(socket, to: ~p"/adopcja/szukaja-domu?#{query_params}")
    {:noreply, socket}
  end

  def query_to_bool(query) do
    case query do
      "on" -> true
      "true" -> true
      "false" -> false
      "" -> nil
      _ -> query
    end
  end

  defp search_tags(cats, search) do
    if String.trim(search) == "" do
      cats
    else
      Enum.filter(cats, fn cats ->
        search = String.downcase(search)

        cats.tags
        |> Enum.map(&String.downcase/1)
        |> Enum.any?(&String.contains?(&1, search))
      end)
    end
  end

  defp parse_date(date_str) when date_str == "", do: nil

  defp parse_date(date_str) do
    [year, month, day] =
      date_str
      |> String.split("-")
      |> Enum.map(&String.to_integer/1)

    Date.new!(year, month, day)
  end

  defp filter_dates(cats, "", ""), do: cats

  defp filter_dates(cats, from, to) do
    from = parse_date(from)
    to = parse_date(to)

    Enum.filter(cats, fn cats ->
      adoption_date = DateTime.to_date(cats.adoption_date)

      within_range =
        (from == nil or Date.compare(adoption_date, from) in [:gt, :eq]) and
          (to == nil or Date.compare(adoption_date, to) in [:lt, :eq])

      true in [within_range]
    end)
  end

  defp filter_colors(cats, colors) do
    if Enum.empty?(colors) do
      cats
    else
      Enum.filter(cats, fn cats ->
        Atom.to_string(cats.color.value) in colors
      end)
    end
  end

  defp filter_genders(cats, genders) do
    if Enum.empty?(genders) do
      cats
    else
      Enum.filter(cats, fn cats ->
        Atom.to_string(cats.sex.value) in genders
      end)
    end
  end

  defp filter_ages(cats, ages) do
    if Enum.empty?(ages) do
      cats
    else
      Enum.filter(cats, fn cats ->
        Atom.to_string(cats.age.value) in ages
      end)
    end
  end

  defp filter_castrated(cats, is_castrated) do
    if is_castrated == nil do
      cats
    else
      Enum.filter(cats, fn cats ->
        cats.castrated.value == is_castrated
      end)
    end
  end

  defp search_names(cats, search) do
    if String.trim(search) == "" do
      cats
    else
      Enum.filter(cats, fn cats ->
        name = String.downcase(cats.name)
        search = String.downcase(search)
        String.contains?(name, search)
      end)
    end
  end

  defp castrated_switch(is_castrated, not_castrated, event) do
    cond do
      not_castrated == true and is_castrated == true ->
        if hd(event) == "is_castrated" do
          true
        else
          false
        end

      is_castrated == true ->
        true

      not_castrated == false ->
        true

      not_castrated == true ->
        false

      is_castrated == false ->
        false

      true ->
        nil
    end
  end

  defp items_per_page, do: [30, 60, 90]

  defp cats_amount_string(amount) do
    cond do
      amount == 1 -> "#{amount} kot"
      amount in [2, 3, 4] -> "#{amount} koty"
      amount > 4 -> "#{amount} kotów"
    end
  end

  def pagination_bar(assigns) do
    assigns =
      assigns
      |> assign(:previous_page, assigns.selected_page - 1)
      |> assign(:next_page, assigns.selected_page + 1)
      |> assign(:first_page, @first_page)

    ~H"""
    <div class="flex flex-row text-xl gap-x-4">
      <button
        :if={@selected_page != @first_page}
        phx-click="select_page"
        class="p-4"
        value={@selected_page - 1}
      >
        <.icon class=" rotate-90 brightness-0" name="chevron_down" />
      </button>

      <.icon :if={@selected_page == @first_page} class="rotate-90 p-4 grayscale" name="chevron_down" />
      <div class="self-center gap-4 hidden lg:inline">
        <button :if={@selected_page > 2} class="w-14 h-14" phx-click="select_page" value={@first_page}>
          <%= @first_page %>
        </button>
        <span :if={@selected_page > 2} class="w-14 h-14">...</span>
        <button
          :if={@selected_page != @first_page}
          class="w-14 h-14"
          phx-click="select_page"
          value={@previous_page}
        >
          <%= @previous_page %>
        </button>
        <button class="font-bold w-14 h-14">
          <%= @selected_page %>
        </button>
        <button
          :if={@selected_page != @last_page}
          class="w-14 h-14"
          phx-click="select_page"
          value={@next_page}
        >
          <%= @next_page %>
        </button>
        <span :if={@selected_page < @last_page - 1} class="w-14 h-14">...</span>

        <button
          :if={@selected_page < @last_page - 1}
          class="w-14 h-14"
          phx-click="select_page"
          value={@last_page}
        >
          <%= @last_page %>
        </button>
      </div>
      <div class="self-center flex flex-row lg:hidden gap-4">
        <span><%= @selected_page %></span>
        <span>z</span>
        <span><%= @last_page %></span>
      </div>
      <.icon :if={@selected_page == @last_page} class="rotate-90 p-4 grayscale" name="chevron_up" />

      <button
        :if={@selected_page != @last_page}
        class="p-4"
        phx-click="select_page"
        value={@selected_page + 1}
      >
        <.icon class="rotate-90 brightness-0" name="chevron_up" />
      </button>
    </div>
    """
  end
end
