defmodule Kotkowo.Plausible do
  @moduledoc false
  alias Kotkowo.Client.ViewUpdate

  require Logger

  @plausible_key System.fetch_env!("PLAUSIBLE_KEY")
  @plausible_url System.fetch_env!("PLAUSIBLE_URL")
  @kotkowo_domain System.fetch_env!("PHX_HOST")
  @api_endpoint "#{@plausible_url}/api/v2/query"

  @headers [
    {"Authorization", "Bearer #{@plausible_key}"},
    {"Content-Type", "application/json"},
    {"Accept", "application/json"}
  ]

  def update_article_views do
    update_article_views(Kotkowo.Client.get_last_view_pull_utc())
  end

  def update_article_views({:error, _err} = res), do: res

  def update_article_views({:ok, last_pull}) do
    now =
      "Europe/Warsaw"
      |> DateTime.now!()
      |> DateTime.to_iso8601()

    query =
      Jason.encode!(%{
        site_id: @kotkowo_domain,
        metrics: ["visitors"],
        dimensions: ["event:page"],
        date_range: [last_pull, now],
        pagination: %{limit: 1000},
        filters: [
          [
            "or",
            [["contains", "event:page", ["/aktualnosci/z-ostatniej-chwili/"]], ["contains", "event:page", ["/porady/"]]]
          ],
          ["not", ["contains", "event:page", ["wszystkie"]]]
        ]
      })

    case HTTPoison.post(@api_endpoint, query, @headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        updates =
          body
          |> Jason.decode!()
          |> Map.get("results")
          |> Enum.map(fn %{"metrics" => [views], "dimensions" => [url]} ->
            {url, views}
          end)
          |> Enum.map(&ViewUpdate.from_url_views/1)
          |> Enum.filter(& &1)

        Kotkowo.Client.update_views(now, updates)

      {:ok, %HTTPoison.Response{status_code: code}} ->
        {:error, "Request failed with status: #{code}"}

      {:error, _reason} = err ->
        err
    end
  end
end
