defmodule Kotkowo.Client.Pagination do
  @moduledoc false
  defstruct [:page, :page_size, :start, :limit]

  @type t() :: %__MODULE__{
          page: non_neg_integer(),
          page_size: non_neg_integer(),
          start: non_neg_integer(),
          limit: non_neg_integer()
        }
end
