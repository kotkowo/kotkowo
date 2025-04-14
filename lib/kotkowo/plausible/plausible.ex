defmodule Kotkowo.Plausible do
  @moduledoc false
  alias Kotkowo.Client.ViewUpdate

  require Logger

  def update_article_views do
    update_article_views(Kotkowo.Client.get_last_view_pull_utc())
  end

  def update_article_views({:error, _err} = res), do: res

  def update_article_views({:ok, last_pull}) do
    plausible_config = Application.get_env(:kotkowo, :plausible)
    plausible_url = Keyword.get(plausible_config, :url)
    plausible_key = Keyword.get(plausible_config, :key)
    kotkowo_domain = Keyword.get(plausible_config, :domain)
    api_endpoint = "#{plausible_url}/api/v2/query"

    now =
      "Europe/Warsaw"
      |> DateTime.now!()
      |> DateTime.to_iso8601()

    query = %{
      site_id: kotkowo_domain,
      metrics: ["visitors"],
      dimensions: ["event:page"],
      date_range: [last_pull, now],
      pagination: %{"limit" => 1000},
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
      Req.post!(json: query, auth: {:bearer, plausible_key}, url: api_endpoint)

    case response.status do
      200 ->
        updates =
          response.body
          |> Map.get("results")
          |> Enum.map(fn %{"metrics" => [views], "dimensions" => [url]} ->
            {url, views}
          end)
          |> Enum.map(&ViewUpdate.from_url_views/1)
          |> Enum.filter(& &1)

        Kotkowo.Client.update_views(now, updates)

      _code ->
        {:error, "Request failed with status: #{inspect(response)}"}
    end
  end
end
