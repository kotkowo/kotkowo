defmodule KotkowoWeb.Hooks.TitleHook do
  @moduledoc false
  import Phoenix.Component
  import Phoenix.LiveView

  @doc """
  Assign title based on current url
  """

  def on_mount(_mode, _params, _session, socket) do
    socket = attach_hook(socket, :assign_title, :handle_params, &assign_title/3)
    {:cont, socket}
  end

  defp find_title_by_path(path) do
    links = KotkowoWeb.Layouts.links()

    segments =
      path
      |> Path.split()
      |> Enum.scan(fn segment, acc ->
        Path.join(acc, segment)
      end)
      # remove default "/"
      |> Enum.drop(1)

    find_closest_to_segments(links, segments, "Kotkowo")
  end

  def find_closest_to_segments(links, segments, default \\ nil)

  def find_closest_to_segments(_links, [], default) do
    default
  end

  def find_closest_to_segments(links, [segment | segments], default) when is_list(links) do
    case Enum.find(links, &String.starts_with?(elem(&1, 1), segment)) do
      {title, _matched_segment, _links, _css_classes} when segments == [] ->
        title

      {title, _matched_segment, links, _css_classes} ->
        find_closest_to_segments(links, segments, title)

      {title, _matched_segment} ->
        title

      nil ->
        default
    end
  end

  def assign_title(_params, uri, socket) do
    uri = URI.parse(uri)
    title = find_title_by_path(uri.path)

    {:cont, assign(socket, :page_title, title)}
  end
end
