defmodule KotkowoWeb.WebHelpers do
  @moduledoc false
  alias Kotkowo.Client.Cat
  alias Kotkowo.Client.Image

  def cat_image_url(%Cat{} = cat) do
    case cat.images do
      [%Image{} = image | _] -> image.url
      _ -> nil
    end
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
