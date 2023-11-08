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
    {:ok, adopted_cats} = StrapiClient.list_adopted_cats()
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

    socket =
      socket
      |> assign(:adopted_cats, adopted_cats)
      |> assign(:filtered_cats, filtered_cats)

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    name = params |> Map.get("name", "") |> String.downcase()
    castrated = params |> Map.get("castrated", nil) |> query_to_bool()
    date_to = Map.get(params, "date_to", "")
    date_from = Map.get(params, "date_from", "")
    tag = params |> Map.get("tag", "") |> String.downcase()
    ages = Map.get(params, "ages", [])
    genders = Map.get(params, "genders", [])

    socket =
      socket
      |> assign(:tag, tag)
      |> assign(:name, name)
      |> assign(:castrated, castrated)
      |> assign(:ages, ages)
      |> assign(:genders, genders)
      |> assign(:date_from, date_from)
      |> assign(:date_to, date_to)

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

    not_castrated = params |> Map.get("not_castrated", nil) |> query_to_bool()

    is_castrated =
      params
      |> Map.get("is_castrated", nil)
      |> query_to_bool()
      |> castrated_switch(not_castrated, event)

    age_keys = Seniority.all()

    ages =
      for key <- age_keys,
          true == params |> Map.get(Atom.to_string(key), false) |> query_to_bool(),
          do: key

    sex_keys = Sex.all()

    genders =
      for key <- sex_keys,
          true == params |> Map.get(Atom.to_string(key), false) |> query_to_bool(),
          do: key

    query_params = %{
      name: name_query,
      tag: tag_query,
      castrated: is_castrated,
      ages: ages,
      genders: genders,
      date_from: date_from,
      date_to: date_to
    }

    filtered_cats =
      cats
      |> search_tags(tag_query)
      |> search_names(name_query)
      |> filter_castrated(is_castrated)
      |> filter_ages(ages)
      |> filter_genders(genders)
      |> filter_dates(date_from, date_to)

    IO.inspect(params)

    socket =
      socket
      |> assign(:filtered_cats, filtered_cats)
      |> push_patch(to: ~p"/aktualnosci/znalazly-dom?#{query_params}")

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
        adopted_cat.cat.sex.value in genders
      end)
    end
  end

  defp filter_ages(cats, ages) do
    if length(ages) == 0 do
      cats
    else
      Enum.filter(cats, fn adopted_cat ->
        adopted_cat.cat.age.value in ages
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
end
