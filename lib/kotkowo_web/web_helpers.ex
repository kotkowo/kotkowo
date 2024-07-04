defmodule KotkowoWeb.WebHelpers do
  @moduledoc false
  def extract_phone_numbers(nil), do: []

  def extract_phone_numbers(contact_information) do
    Enum.map(contact_information, &Map.get(&1, :phone_number))
  end

  def beautify_phone_number(phone_number) do
    case String.length(phone_number) do
      9 ->
        "#{String.slice(phone_number, 0..2)} #{String.slice(phone_number, 3..5)} #{String.slice(phone_number, 6..8)}"

      12 ->
        "#{String.slice(phone_number, 0..2)} #{String.slice(phone_number, 3..5)} #{String.slice(phone_number, 6..8)} #{String.slice(phone_number, 9..11)}"

      _ ->
        phone_number
    end
  end
end
