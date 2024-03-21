defmodule Kotkowo.Client.Opts do
  @moduledoc false
  alias Kotkowo.Client.Pagination

  defstruct [:filter, :pagination, sort: []]

  @type filter() :: Kotkowo.Client.Cat.Filter.t()

  @type t() :: %__MODULE__{
          filter: filter() | nil,
          pagination: Pagination.t() | nil,
          sort: [String.t()] | nil
        }
end
