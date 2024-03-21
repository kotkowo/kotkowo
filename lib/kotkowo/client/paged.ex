defmodule Kotkowo.Client.Paged do
  @moduledoc false
  alias Kotkowo.Client.Cat

  defstruct [:items, :total, :page, :page_size, :page_count]

  @type item() :: Cat.t()

  @type t() :: %__MODULE__{
          items: [item()],
          total: non_neg_integer(),
          page: non_neg_integer(),
          page_size: non_neg_integer(),
          page_count: non_neg_integer()
        }
end
