defmodule Kotkowo.Client.Cat.Filter do
  @moduledoc """
  A module for defining and working with filters for cats in the Kotkowo client.
  """

  use Gradient.TypeAnnotation

  alias Kotkowo.Client.Cat

  defstruct [:sex, :age, :color, :castrated, :tags, :name]

  @typedoc """
  A type representing a field that can be filtered.
  """
  @type field() :: :name | :sex | :age | :color | :castrated | :tags

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
          sex: filter(Cat.Sex.t()) | nil,
          age: filter(Cat.Age.t()) | nil,
          color: filter(Cat.Color.t()) | nil,
          castrated: filter(Cat.castrated()) | nil,
          tags: filter(Cat.tags()) | nil
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
      name: {:contains_ci, "Fluffy"}
    }

    iex> Kotkowo.Client.Cat.Filter.from_map(%{name: "Fluffy", sex: :female, color: [:black, :ginger]}) 
    %Kotkowo.Client.Cat.Filter{
      sex: {:equals, :female},
      age: nil,
      color: {:in, [:black, :ginger]},
      castrated: nil,
      tags: nil,
      name: {:contains_ci, "Fluffy"}
    }
  """
  @spec from_map(map()) :: t()
  def from_map(map) when is_map(map) do
    map
    |> Enum.map(&parse_field/1)
    |> then(&struct!(__MODULE__, &1))
    |> assert_type(t())
  end

  @spec parse_field({field(), any()}) :: {field(), filter(any())}
  defp parse_field({:name, val}) do
    {:name, {:contains_ci, val}}
  end

  defp parse_field({:tags, vals}) when is_list(vals) do
    {:tags, {:in, vals}}
  end

  defp parse_field({:tags, val}) do
    {:tags, {:contains_ci, val}}
  end

  defp parse_field({:castrated, val}) do
    {:castrated, {:equals, val}}
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

  def to_param(%__MODULE__{} = filter) do
    {_, name} = filter.name
    {_, sex} = filter.sex

    URI.encode("cat[name]=#{name}&cat[sex]=#{sex}&cat[age][]=adult")
  end
end
