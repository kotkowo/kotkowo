defmodule Kotkowo.Client.Cat.Filter do
  @moduledoc false
  alias Kotkowo.Client.Cat

  defstruct [:sex, :age, :color, :castrated, :tags]

  @type t() :: %__MODULE__{
          sex: Cat.sex() | nil,
          age: Cat.age() | nil,
          color: Cat.color() | nil,
          castrated: Cat.castrated() | nil,
          tags: Cat.tags() | nil
        }
end
