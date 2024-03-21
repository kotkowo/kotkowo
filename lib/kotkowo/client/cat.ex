defmodule Kotkowo.Client.Cat do
  @moduledoc false
  alias Kotkowo.Client.Image

  @type sex() :: :male | :female
  @type age() :: :junior | :adult | :senior
  @type color() :: :black | :gray | :tricolor | :patched | :ginger | :other_color
  @type castrated() :: boolean()
  @type tags() :: [String.t()]
  @type fiv_felv() :: :negative | :positive
  @type medical_status() :: :tested_and_vaccinated

  defstruct [
    :id,
    :name,
    :description,
    :color,
    :tags,
    :slug,
    :description_heading,
    :sex,
    :is_dead,
    :fiv_felv,
    :castrated,
    :healthy,
    :medical_status,
    :images
  ]

  @type t() :: %__MODULE__{
          id: String.t() | nil,
          name: String.t(),
          description: String.t() | nil,
          color: color() | nil,
          tags: tags(),
          slug: String.t() | nil,
          description_heading: String.t() | nil,
          sex: sex() | nil,
          is_dead: boolean(),
          fiv_felv: fiv_felv() | nil,
          castrated: boolean(),
          healthy: boolean(),
          medical_status: medical_status() | nil,
          images: [Image.t()]
        }
end
