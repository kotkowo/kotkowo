defmodule URLHelper do
  def interpolate_params(url_pattern, param_map) do
    interpolate_params(url_pattern, param_map, [])
  end

  defp interpolate_params("", _param_map, acc) do
    String.reverse(Enum.join(acc))
  end

  defp interpolate_params(<<":", rest::binary>>, param_map, acc) do
    {param_name, rest} = String.split(rest, "/", parts: 2)

    case Map.fetch(param_map, param_name) do
      {:ok, param_value} ->
        interpolate_params(rest, param_map, [param_value | acc])

      :error ->
        raise ArgumentError, "Missing parameter: #{param_name}"
    end
  end

  defp interpolate_params(<<c::utf8, rest::binary>>, param_map, acc) do
    interpolate_params(rest, param_map, [<<c::utf8>> | acc])
  end
end
