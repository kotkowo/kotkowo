defmodule Kotkowo.Cat do
  @moduledoc false
  defstruct [
    :id,
    :slug,
    :name,
    :created_at,
    :updated_at,
    :published_at,
    :gallery,
    :description_heading,
    :description,
    :age,
    :sex,
    :is_dead,
    :fiv_felv,
    :color,
    :castrated,
    :healthy,
    :medical_status,
    :tags
  ]
end
