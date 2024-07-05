defmodule Kotkowo.Client.DateTime do
  @moduledoc false
  @type t() :: String.t()
  @spec format_date(t(), String.t()) :: String.t()
  def format_date(date, format) do
    date
    |> to_datetime()
    |> Calendar.strftime(format)
  end

  @spec to_datetime(t()) :: DateTime.t()
  def to_datetime(date) do
    {:ok, date, _offset} = DateTime.from_iso8601(date)
    date
  end
end
