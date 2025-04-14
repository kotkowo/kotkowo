defmodule Kotkowo.Client.ViewUpdate do
  @moduledoc false
  alias Kotkowo.Client.ViewUpdate

  defstruct [
    :content_type,
    :id,
    :field,
    :amount
  ]

  @type t() :: %__MODULE__{
          content_type: String.t(),
          id: String.t(),
          field: String.t(),
          amount: integer()
        }

  @view_groups_mapping %{
    "aktualnosci" => "api::announcement.announcement",
    "porady" => "api::advice.advice"
  }

  def from_url_views({endpoint, views}) do
    @view_groups_mapping
    |> Map.to_list()
    |> Enum.find_value(fn {group_name, api_mapping} ->
      match_view_update(endpoint, group_name, api_mapping, views)
    end)
  end

  defp match_view_update(endpoint, group_name, api_mapping, views) do
    if String.contains?(endpoint, group_name) do
      id = extract_id_from_endpoint(endpoint)

      unless is_nil(id) do
        %ViewUpdate{
          content_type: api_mapping,
          id: id,
          amount: views,
          field: "views"
        }
      end
    end
  end

  defp extract_id_from_endpoint({id, _rest}), do: to_string(id)
  defp extract_id_from_endpoint(:error), do: nil

  defp extract_id_from_endpoint(endpoint) do
    endpoint
    |> URI.parse()
    |> Map.get(:path)
    |> String.split("/", trim: true)
    |> List.last()
    |> Integer.parse()
    |> extract_id_from_endpoint()
  end
end
