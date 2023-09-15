defmodule Kotkowo.Cats.Cat do
  defmodule Id do
    use Attribute, :integer
  end

  defmodule Name do
    use Attribute, :string
  end

  defmodule Sex do
    use Attribute, enum: [:male, :female]

    def to_string(%_{value: :male}), do: "Kot"
    def to_string(%_{value: :female}), do: "Kotka"
  end

  defmodule Seniority do
    use Attribute, enum: [:adult, :senior, :junior]
  end

  defmodule Health do
    use Attribute, enum: [:examined_and_vaccinated]
  end

  defmodule Castrated do
    use Attribute, :boolean
  end

  defmodule FivFelvPassed do
    use Attribute, :boolean
  end

  defmodule UpdatedAt do
    use Attribute, :datetime
  end

  defmodule CreatedAt do
    use Attribute, :datetime
  end

  defstruct [
    :id,
    :name,
    :sex,
    :seniority,
    :health,
    :castrated,
    :fiv_felt_passed,
    :updated_at,
    :created_at
  ]

  def parse(%{"data" => data}) do
    id = data |> Map.get("id") |> Id.parse()
    name = data |> get_in(["attributes", "name"]) |> Name.parse()
    sex = data |> get_in(["attributes", "sex"]) |> Sex.parse()
    seniority = data |> get_in(["attributes", "seniority"]) |> Seniority.parse()
    health = data |> get_in(["attributes", "health"]) |> Health.parse()
    castrated = data |> get_in(["attributes", "health"]) |> Castrated.parse()
    fiv_felv_passed = data |> get_in(["attributes", "fiv_felv_passed"]) |> FivFelvPassed.parse()
    created_at = data |> get_in(["attributes", "createdAt"]) |> CreatedAt.parse()
    updated_at = data |> get_in(["attributes", "updatedAt"]) |> UpdatedAt.parse()

    %__MODULE__{
      id: id,
      name: name,
      sex: sex,
      seniority: seniority,
      health: health,
      castrated: castrated,
      fiv_felt_passed: fiv_felv_passed,
      updated_at: updated_at,
      created_at: created_at
    }
  end
end
