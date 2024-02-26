defmodule KotkowoWeb.NewsLive.FoundHome do
  @moduledoc false
  use KotkowoWeb, :live_view

  import KotkowoWeb.Components.Drawers
  import KotkowoWeb.Components.Static.HowYouCanHelpSection

  alias Kotkowo.Attributes.Color
  alias Kotkowo.Attributes.Seniority
  alias Kotkowo.Attributes.Sex
  alias Kotkowo.GalleryImage
  alias Kotkowo.StrapiClient

  @params_default %{
    limit: 30,
    page: 1,
    name: "",
    seniority: [],
    sexes: [],
    castrated: nil,
    tag: "",
    colors: [],
    date_from: "",
    date_to: ""
  }
  @params_keys @params_default |> Map.keys() |> Enum.map(&to_string/1)
  @impl true
  def mount(_params, _session, socket) do
    {:ok, adopted_cats} = StrapiClient.list_adopted_cats()

    socket = assign(socket, :adopted_cats, adopted_cats)

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    parsed_params =
      params
      |> Map.take(@params_keys)
      |> Map.new(&parse_param/1)
      |> then(&Map.merge(@params_default, &1))

    filtered_cats =
      socket.assigns.adopted_cats
      |> search_tags(parsed_params.tag)
      |> search_names(parsed_params.name)
      |> filter_castrated(parsed_params.castrated)
      |> filter_seniority(parsed_params.seniority)
      |> filter_sexes(parsed_params.sexes)
      |> filter_colors(parsed_params.colors)
      |> filter_dates(parsed_params.date_from, parsed_params.date_to)

    %{page: page, offset: offset, max_page: max_page} = parse_page_meta(parsed_params, filtered_cats)

    query_params = %{
      parsed_params
      | page: page
    }

    socket =
      socket
      |> assign(:query_params, query_params)
      |> assign(:filtered_cats, Enum.slice(filtered_cats, offset, parsed_params.limit))
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
    limit = socket.assigns.query_params.limit
    page = socket.assigns.query_params.page

    not_castrated = params |> Map.get("not_castrated", nil) |> parse_checkbox()

    is_castrated =
      params
      |> Map.get("is_castrated", nil)
      |> parse_checkbox()
      |> castrated_switch(not_castrated, event)

    filter_default = %{sexes: [], seniority: [], colors: []}
    # create string -> atom mapping e.g. %{"senior" => :senior}
    checkbox_mappings =
      Enum.reduce(Seniority.all() ++ Sex.all() ++ Color.all(), %{}, &Map.put(&2, Atom.to_string(&1), &1))

    # take all matching key value pairs that are checkboxes
    %{seniority: seniority, sexes: sexes, colors: colors} =
      params
      |> Map.take(Map.keys(checkbox_mappings))
      # filter out only ones that evaluate to `true`  and then for each true return the atom value
      # e.g. for %{"senior" => "true} we return [:senior]
      |> Enum.reduce([], fn {key, val}, acc -> if parse_checkbox(val), do: [checkbox_mappings[key] | acc], else: acc end)
      # group_by the category
      |> Enum.group_by(fn x ->
        cond do
          x in Seniority.all() -> :seniority
          x in Sex.all() -> :sexes
          x in Color.all() -> :colors
        end
      end)
      |> then(&Map.merge(filter_default, &1))

    query_params = %{
      name: name_query,
      tag: tag_query,
      castrated: is_castrated,
      seniority: seniority,
      sexes: sexes,
      date_from: date_from,
      colors: colors,
      date_to: date_to,
      page: page,
      limit: limit
    }

    socket = push_patch(socket, to: ~p"/aktualnosci/znalazly-dom?#{query_params}")

    {:noreply, socket}
  end

  @impl true
  def handle_event("items_amount", %{"items_per_page" => amount}, socket) do
    limit = parse_limit(amount)
    max_page = socket.assigns.filtered_cats |> length() |> div(limit) |> parse_limit()

    query_params = %{socket.assigns.query_params | limit: limit}

    socket =
      socket
      |> assign(:max_page, max_page)
      |> push_patch(to: ~p"/aktualnosci/znalazly-dom?#{query_params}")

    {:noreply, socket}
  end

  @impl true
  def handle_event("select_page", %{"value" => page}, socket) do
    query_params = %{socket.assigns.query_params | page: page}
    socket = push_patch(socket, to: ~p"/aktualnosci/znalazly-dom?#{query_params}")
    {:noreply, socket}
  end

  defp parse_page_meta(params, cats) do
    max_page =
      cats
      |> length()
      |> Kernel./(params.limit)
      |> ceil()
      |> max(@params_default.page)

    page =
      cond do
        params.page < @params_default.page -> @params_default.page
        params.page > max_page -> max_page
        true -> params.page
      end

    offset = (page - 1) * params.limit
    %{page: page, offset: offset, max_page: max_page}
  end

  defp parse_param({"castrated", value}) do
    castrated = parse_checkbox(value)
    {:castrated, castrated}
  end

  defp parse_param({"limit", value}) do
    limit = parse_limit(value)
    {:limit, limit}
  end

  defp parse_param({"page", value}) do
    page = parse_limit(value)
    {:page, page}
  end

  defp parse_param({key, value}) do
    {String.to_existing_atom(key), value}
  end

  def parse_checkbox(query) do
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

        adopted_cat.cat.tags
        |> Enum.map(&String.downcase/1)
        |> Enum.any?(&String.contains?(&1, search))
      end)
    end
  end

  defp parse_limit(limit) when is_float(limit), do: limit |> floor() |> parse_limit()
  defp parse_limit(limit) when is_binary(limit), do: limit |> String.to_integer() |> parse_limit()
  defp parse_limit(limit) when is_integer(limit), do: max(limit, 1)
  defp parse_limit(_), do: @params_default.limit

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

    Enum.filter(cats, fn adopted_cat ->
      adoption_date = DateTime.to_date(adopted_cat.adoption_date)

      within_range =
        (from == nil or Date.compare(adoption_date, from) in [:gt, :eq]) and
          (to == nil or Date.compare(adoption_date, to) in [:lt, :eq])

      true in [within_range]
    end)
  end

  defp filter_colors(cats, []), do: cats

  defp filter_colors(cats, colors) do
    Enum.filter(cats, fn adopted_cat ->
      Atom.to_string(adopted_cat.cat.color.value) in colors
    end)
  end

  defp filter_sexes(cats, []), do: cats

  defp filter_sexes(cats, sexes) do
    Enum.filter(cats, fn adopted_cat ->
      Atom.to_string(adopted_cat.cat.sex.value) in sexes
    end)
  end

  defp filter_seniority(cats, []), do: cats

  defp filter_seniority(cats, seniority) do
    Enum.filter(cats, fn adopted_cat ->
      Atom.to_string(adopted_cat.cat.age.value) in seniority
    end)
  end

  defp filter_castrated(cats, nil), do: cats

  defp filter_castrated(cats, is_castrated) do
    Enum.filter(cats, fn adopted_cat ->
      adopted_cat.cat.castrated.value == is_castrated
    end)
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

  defp items_per_page, do: [30, 60, 90]

  def pagination_bar(assigns) do
    assigns =
      assigns
      |> assign(:previous_page, assigns.selected_page - 1)
      |> assign(:next_page, assigns.selected_page + 1)
      |> assign(:first_page, @params_default.page)

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
