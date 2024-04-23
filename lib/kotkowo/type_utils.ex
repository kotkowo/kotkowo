defmodule TypeUtils do
  # https://elixirforum.com/t/dynamically-generate-typespecs-from-module-attribute-list/7078/5
  @moduledoc false
  def list_to_typespec(list) when is_list(list) do
    Enum.reduce(list, &{:|, [], [&1, &2]})
  end
end
