defmodule Kotkowo.Client.Cat do
  @moduledoc false
  alias Kotkowo.Client.Cat.Age
  alias Kotkowo.Client.Cat.Color
  alias Kotkowo.Client.Cat.Sex
  alias Kotkowo.Client.Image

  @type castrated() :: boolean()
  @type tags() :: [String.t()]
  @type fiv_felv() :: :negative | :positive
  @type medical_status() :: :tested_and_vaccinated

  defstruct [
    :id,
    :age,
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
          age: Age.t() | nil,
          name: String.t(),
          description: String.t() | nil,
          color: Color.t() | nil,
          tags: tags(),
          slug: String.t() | nil,
          description_heading: String.t() | nil,
          sex: Sex.t() | nil,
          is_dead: boolean(),
          fiv_felv: fiv_felv() | nil,
          castrated: boolean(),
          healthy: boolean(),
          medical_status: medical_status() | nil,
          images: [Image.t()]
        }
end
