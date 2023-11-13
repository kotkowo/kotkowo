defmodule KotkowoWeb.NewsLive.FoundHome do
  @moduledoc false
  use KotkowoWeb, :live_view

  import KotkowoWeb.Components.Static.HowYouCanHelpSection

  alias Kotkowo.Attributes.Seniority
  alias Kotkowo.Attributes.Sex
  alias Kotkowo.GalleryImage
  alias Kotkowo.StrapiClient

  @first_page 1
  @default_limit 30
  @impl true
  def mount(params, _session, socket) do
    limit = params |> Map.get("limit", Integer.to_string(@default_limit)) |> String.to_integer()
    {:ok, max_page} = StrapiClient.list_adopted_cats_pages(limit)
    max_page = max(1, max_page)

    socket =
      assign(socket, :max_page, max_page)

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    {:ok, adopted_cats} = StrapiClient.list_adopted_cats()

    limit = params |> Map.get("limit", Integer.to_string(@default_limit)) |> String.to_integer()
    page = params |> Map.get("page", Integer.to_string(@first_page)) |> String.to_integer()

    name = params |> Map.get("name", "") |> String.downcase()
    ages = Map.get(params, "ages", [])
    genders = Map.get(params, "genders", [])
    castrated = params |> Map.get("castrated", nil) |> query_to_bool()
    tag = params |> Map.get("tag", "") |> String.downcase()
    date_to = Map.get(params, "date_to", "")
    date_from = Map.get(params, "date_from", "")

    filtered_cats =
      adopted_cats
      |> search_tags(tag)
      |> search_names(name)
      |> filter_castrated(castrated)
      |> filter_ages(ages)
      |> filter_genders(genders)
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
      |> assign(:date_to, date_to)
      |> assign(:limit, limit)
      |> assign(:page, page)
      |> assign(:adopted_cats, adopted_cats)
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
    cats = socket.assigns.adopted_cats

    limit = Map.get(socket.assigns, :limit, Integer.to_string(@default_limit))
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

    filtered_cats =
      cats
      |> search_tags(tag_query)
      |> search_names(name_query)
      |> filter_castrated(is_castrated)
      |> filter_ages(ages)
      |> filter_genders(genders)
      |> filter_dates(date_from, date_to)

    max_page = max(@first_page, ceil(length(filtered_cats) / limit))

    page =
      cond do
        page < @first_page -> @first_page
        page > max_page -> max_page
        true -> page
      end

    query_params = %{
      name: name_query,
      tag: tag_query,
      castrated: is_castrated,
      ages: ages,
      genders: genders,
      date_from: date_from,
      date_to: date_to,
      page: page,
      limit: limit
    }

    offset = (page - 1) * limit

    socket =
      socket
      |> assign(:filtered_cats, Enum.slice(filtered_cats, offset, limit))
      |> push_patch(to: ~p"/aktualnosci/znalazly-dom?#{query_params}")

    {:noreply, socket}
  end

  @impl true
  def handle_event("items_amount", %{"items_per_page" => amount}, socket) do
    limit = String.to_integer(amount)
    max_page = max(@first_page, socket.assigns.filtered_cats |> length() |> div(limit))

    query_params = %{
      name: socket.assigns.name,
      tag: socket.assigns.tag,
      castrated: socket.assigns.castrated,
      ages: socket.assigns.ages,
      genders: socket.assigns.genders,
      date_from: socket.assigns.date_from,
      date_to: socket.assigns.date_to,
      page: socket.assigns.page,
      limit: limit
    }

    socket =
      socket
      |> assign(:max_page, max_page)
      |> push_patch(to: ~p"/aktualnosci/znalazly-dom?#{query_params}")

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
      date_to: socket.assigns.date_to,
      page: page,
      limit: socket.assigns.limit
    }

    socket = push_patch(socket, to: ~p"/aktualnosci/znalazly-dom?#{query_params}")
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
      Enum.filter(cats, fn adopted_cat ->
        search = String.downcase(search)

        Enum.any?(adopted_cat.cat.tags, fn tag -> tag |> String.downcase() |> String.contains?(search) end)
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

  defp filter_dates(cats, from, to) do
    if from == "" and to == "" do
      cats
    else
      from = parse_date(from)
      to = parse_date(to)

      Enum.filter(cats, fn adopted_cat ->
        adoption_date = DateTime.to_date(adopted_cat.adoption_date)

        case {from, to} do
          {nil, nil} ->
            true

          {nil, _} ->
            case Date.compare(adoption_date, to) do
              :lt -> true
              :eq -> true
              _ -> false
            end

          {_, nil} ->
            case Date.compare(adoption_date, from) do
              :gt -> true
              :eq -> true
              _ -> false
            end

          {_, _} ->
            case Date.compare(adoption_date, to) do
              :lt -> true
              :eq -> true
              _ -> false
            end and
              case Date.compare(adoption_date, from) do
                :gt -> true
                :eq -> true
                _ -> false
              end
        end
      end)
    end
  end

  defp filter_genders(cats, genders) do
    if length(genders) == 0 do
      cats
    else
      Enum.filter(cats, fn adopted_cat ->
        Atom.to_string(adopted_cat.cat.sex.value) in genders
      end)
    end
  end

  defp filter_ages(cats, ages) do
    if length(ages) == 0 do
      cats
    else
      Enum.filter(cats, fn adopted_cat ->
        Atom.to_string(adopted_cat.cat.age.value) in ages
      end)
    end
  end

  defp filter_castrated(cats, is_castrated) do
    if is_castrated == nil do
      cats
    else
      Enum.filter(cats, fn adopted_cat ->
        adopted_cat.cat.castrated.value == is_castrated
      end)
    end
  end

  defp search_names(cats, search) do
    if String.trim(search) == "" do
      cats
    else
      Enum.filter(cats, fn adopted_cat ->
        name = String.downcase(adopted_cat.cat.name)
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

  defp items_per_page, do: [1, 2, 3]

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
