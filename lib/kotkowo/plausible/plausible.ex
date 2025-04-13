defmodule Kotkowo.Plausible do
  @moduledoc false
  alias Kotkowo.Client.ViewUpdate

  require Logger

  def update_article_views do
    update_article_views(Kotkowo.Client.get_last_view_pull_utc())
  end

  def update_article_views({:error, _err} = res), do: res

  def update_article_views({:ok, last_pull}) do
    [url: plausible_url, key: plausible_key] = Application.get_env(:kotkowo, :plausible)
    kotkowo_domain = Application.get_env(:kotkowo, KotkowoWeb.Endpoint)[:url][:host]
    api_endpoint = "#{plausible_url}/api/v2/query"

    headers = [
      {"Authorization", "Bearer #{plausible_key}"},
      {"Content-Type", "application/json"},
      {"Accept", "application/json"}
    ]

    now =
      "Europe/Warsaw"
      |> DateTime.now!()
      |> DateTime.to_iso8601()

    query = %{
      site_id: kotkowo_domain,
      metrics: ["visitors"],
      dimensions: ["event:page"],
      date_range: [last_pull, now],
      pagination: %{limit: 1000},
      filters: [
        [
          "or",
          [
            ["contains", "event:page", ["/aktualnosci/z-ostatniej-chwili/"]],
            ["contains", "event:page", ["/porady/"]]
          ]
        ],
        ["not", ["contains", "event:page", ["wszystkie"]]]
      ]
    }

    response =
      Req.post!(
        url: api_endpoint,
        headers: headers,
        json: query
      )

    case response.status do
      200 ->
        updates =
          response.body
          |> Jason.decode!()
          |> Map.get("results")
          |> Enum.map(fn %{"metrics" => [views], "dimensions" => [url]} ->
            {url, views}
          end)
          |> Enum.map(&ViewUpdate.from_url_views/1)
          |> Enum.filter(& &1)

        Kotkowo.Client.update_views(now, updates)

      code ->
        {:error, "Request failed with status: #{code}"}
    end
  end
end
