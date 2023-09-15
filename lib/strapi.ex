defmodule Strapi do
  defp get_config do
    Application.get_env(:kotkowo, :strapi, %{})
  end

  defp neuron_opts do
    config = get_config()
    headers = [authorization: "Bearer #{config[:api_key]}"]

    [url: config[:endpoint], headers: headers]
    |> dbg()
  end

  def query(query, vars \\ %{}) do
    Neuron.query(query, vars, neuron_opts())
    |> unwrap()
  end

  defp unwrap({:ok, %Neuron.Response{body: body}}), do: {:ok, body}
  defp unwrap(other), do: other
end
