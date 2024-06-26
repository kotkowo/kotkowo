defmodule Kotkowo.Client.Cat.Filter do
  @moduledoc """
  A module for defining and working with filters for cats in the Kotkowo client.
  """

  use Gradient.TypeAnnotation

  alias Kotkowo.Client.Cat
  alias Kotkowo.Client.Cat.Age
  alias Kotkowo.Client.Cat.Color
  alias Kotkowo.Client.Cat.Sex

  defstruct [:sex, :age, :color, :castrated, :tags, :name, :is_dead, :chip_number]

  @typedoc """
  A type representing a field that can be filtered.
  """
  @type field() :: :name | :sex | :age | :color | :castrated | :tags | :is_dead | :chip_number
  @typedoc """
  A type representing a filter operation for a property.
  """
  @type filter(prop_type) ::
          {:contains, prop_type}
          | {:contains_ci, prop_type}
          | {:equals, prop_type}
          | {:equals_ci, prop_type}
          | {:or, [prop_type]}
          | {:in, [prop_type]}

  @typedoc """
  A type representing a filter structure for cats.
  """
  @type t() :: %__MODULE__{
          name: filter(String.t()) | nil,
          chip_number: filter(String.t()) | nil,
          sex: filter(Cat.Sex.t()) | nil,
          age: filter(Cat.Age.t()) | nil,
          color: filter(Cat.Color.t()) | nil,
          castrated: filter(Cat.castrated()) | nil,
          tags: filter(Cat.tags()) | nil,
          is_dead: filter(Cat.is_dead()) | nil
        }

  @doc """
  Converts a map into a filter structure for cats.

  This function takes a map where keys correspond to filterable fields of a cat and values represent the filter criteria. It then constructs a filter structure (`t()`) based on these criteria.

  ### Filter Options Applied

  #### For single values:
  - `:contains_ci` for `:name`
  - `:equals` for `:castrated`, `:sex`, `:age`, `:color`
  #### For lists of values:
  - `:in` for `:tags`, `:color`, `:sex`, `:age`

  ### Field Filters

  - `:name` - Filters cats by their name.
  - `:sex` - Filters cats by their sex.
  - `:age` - Filters cats by their age.
  - `:color` - Filters cats by their color.
  - `:castrated` - Filters cats by their castration status.
  - `:tags` - Filters cats by their tags.
  - ':is_dead' - Filters cats by their alive status  

  ### Parameters

  - `map`: A map with keys corresponding to filterable fields and values representing the filter criteria.

  ### Returns

  A filter structure (`t()`) based on the provided map.

  ### Examples

    iex> Kotkowo.Client.Cat.Filter.from_map(%{name: "Fluffy", sex: :female}) 
    %Kotkowo.Client.Cat.Filter{
      sex: {:equals, :female},
      age: nil,
      color: nil,
      castrated: nil,
      tags: nil,
      name: {:contains_ci, "Fluffy"},
      is_dead: nil
    }

    iex> Kotkowo.Client.Cat.Filter.from_map(%{name: "Fluffy", sex: :female, color: [:black, :ginger]}) 
    %Kotkowo.Client.Cat.Filter{
      sex: {:equals, :female},
      age: nil,
      color: {:in, [:black, :ginger]},
      castrated: nil,
      tags: nil,
      name: {:contains_ci, "Fluffy"},
      is_dead: nil
    }
  """
  @spec from_map(map()) :: t()
  def from_map(map) when is_map(map) do
    map
    |> Enum.map(&parse_field/1)
    |> then(&struct!(__MODULE__, &1))
    |> assert_type(t())
  end

  @spec parse_field({field(), any()}) :: {field(), filter(any()) | []}
  defp parse_field({:name, val}) do
    {:name, {:contains_ci, val}}
  end

  defp parse_field({:tags, nil}) do
    {:tags, []}
  end

  defp parse_field({:tags, vals}) when is_list(vals) do
    {:tags, vals}
  end

  defp parse_field({:castrated, val}) do
    {:castrated, val}
  end

  defp parse_field({:is_dead, val}) do
    {:is_dead, val}
  end

  defp parse_field({:chip_number, val}) do
    {:chip_number, val}
  end

  defp parse_field({:color, vals}) when is_list(vals) do
    {:color, {:in, vals}}
  end

  defp parse_field({:color, val}) do
    {:color, {:equals, val}}
  end

  defp parse_field({:age, vals}) when is_list(vals) do
    {:age, {:in, vals}}
  end

  defp parse_field({:age, val}) do
    {:age, {:equals, val}}
  end

  defp parse_field({:sex, vals}) when is_list(vals) do
    {:sex, {:in, vals}}
  end

  defp parse_field({:sex, val}) do
    {:sex, {:equals, val}}
  end

  def to_param(_field, nil), do: ""
  def to_param(_field, {_, []}), do: ""
  def to_param(_field, {_, nil}), do: ""

  def to_param(field, values) when is_list(values) do
    to_param(field, {nil, values})
  end

  def to_param(field, {_, values}) when is_list(values) do
    base = "cat[#{field}][]="
    "&" <> Enum.map_join(values, "&", fn val -> "#{base}#{val}" end)
  end

  def to_param(field, {_, value}) do
    "&cat[#{field}]=#{value}"
  end

  def to_param(field, value) do
    "&cat[#{field}]=#{value}"
  end

  def to_param(%__MODULE__{} = filter) do
    params =
      Enum.join([
        to_param(:chip_number, filter.chip_number),
        to_param(:name, filter.name),
        to_param(:sex, filter.sex),
        to_param(:color, filter.color),
        to_param(:castrated, filter.castrated),
        to_param(:tags, filter.tags),
        to_param(:age, filter.age),
        to_param(:is_dead, filter.is_dead)
      ])

    URI.encode(params)
  end

  def from_params(nil), do: %__MODULE__{}

  def from_params(params) do
    colors =
      params
      |> Map.get("color", [])
      |> Enum.map(&Color.from_string/1)
      |> Enum.filter(&(not is_nil(&1)))

    colors = if colors == [], do: nil, else: colors
    sex = Sex.from_string(params["sex"])

    castrated =
      case params["castrated"] do
        "true" -> true
        "false" -> false
        _ -> nil
      end

    is_dead = Map.get(params, "is_dead", nil)

    ages =
      params
      |> Map.get("age", [])
      |> Enum.map(&Age.from_string/1)
      |> Enum.filter(&(not is_nil(&1)))

    ages = if ages == [], do: nil, else: ages

    map = %{
      name: params["name"],
      chip_number: params["chip_number"],
      color: colors,
      tags: params["tags"],
      sex: sex,
      castrated: castrated,
      age: ages,
      is_dead: is_dead
    }

    map
    |> Map.filter(fn {_k, v} ->
      not is_nil(v) or (is_list(v) and Enum.empty?(v))
    end)
    |> from_map()
  end
end
