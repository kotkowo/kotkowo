defmodule Kotkowo.Client do
  @moduledoc false
  use Rustler, otp_app: :kotkowo, crate: :client

  alias Kotkowo.Client.Cat
  alias Kotkowo.Client.Opts
  alias Kotkowo.Client.Pagination

  def list_cats(_options \\ %Opts{}), do: :erlang.nif_error(:nif_not_loaded)

  @doc """
  Creates a new client configuration with the specified options.

  This function accepts a list of options that can be used to configure the client's behavior, such as sorting, pagination, and filtering. The options are processed in a way that allows for flexible configuration of the client's behavior.

  ### Options

  - `:sort` - A binary string specifying the sort order. Multiple sort options can be provided, and they will be applied in the order they are received.
  - `:page_size` - An integer specifying the number of items per page for pagination.
  - `:page` - An integer specifying the current page number for pagination.
  - `:start` - An integer specifying the starting index for pagination.
  - `:limit` - An integer specifying the maximum number of items to return.
  - `:cat` - A map specifying filters for cats. This map is converted into a `Cat.Filter` structure using `Cat.Filter.from_map/1`.

  ### Parameters

  - `opts` - A list of options to configure the client. This can be a single option or a list of options.

  ### Returns

  A new `Opts` struct configured with the provided options.

  ### Examples
    iex> Kotkowo.Client.new(cat: %{name: "Fluffy"}, sort: "name:asc", sort: "sex:desc", limit: 10, start: 10)
    %Kotkowo.Client.Opts{
    filter: %Kotkowo.Client.Cat.Filter{
      sex: nil,
      age: nil,
      color: nil,
      castrated: nil,
      tags: nil,
      name: {:contains_ci, "Fluffy"}
    },
    pagination: %Kotkowo.Client.Pagination{
      page: nil,
      page_size: nil,
      start: 10,
      limit: 10
    },
    sort: ["sex:desc", "name:asc"]
    }
  """
  def new(opts \\ [])

  def new(opts) when is_list(opts) do
    Enum.reduce(opts, %Opts{}, &parse_option/2)
  end

  def new(opt), do: new([opt])

  defp parse_option({_, nil}, %Opts{} = acc), do: acc

  defp parse_option({:sort, new_sort}, %Opts{} = acc) when is_binary(new_sort) do
    sort =
      case acc.sort do
        nil -> []
        x when is_list(x) -> x
      end

    %Opts{acc | sort: [new_sort | sort]}
  end

  defp parse_option({:page_size, page_size}, %Opts{} = acc) when is_integer(page_size) do
    merge_pagination(acc, %Pagination{page_size: page_size})
  end

  defp parse_option({:page, page}, %Opts{} = acc) when is_integer(page) do
    merge_pagination(acc, %Pagination{page: page})
  end

  defp parse_option({:start, start}, %Opts{} = acc) when is_integer(start) do
    merge_pagination(acc, %Pagination{start: start})
  end

  defp parse_option({:limit, limit}, %Opts{} = acc) when is_integer(limit) do
    merge_pagination(acc, %Pagination{limit: limit})
  end

  defp parse_option({:cat, filter}, %Opts{} = acc) when is_map(filter), do: merge_filter(acc, Cat.Filter.from_map(filter))

  defp parse_option({:filter, %Cat.Filter{} = filter}, %Opts{} = acc) when is_map(filter), do: merge_filter(acc, filter)

  defp merge_filter(%Opts{filter: nil} = opts, filter) do
    %Opts{opts | filter: filter}
  end

  defp merge_filter(%Opts{filter: %current_mod{} = left} = opts, %append_mod{} = right) do
    if current_mod != append_mod do
      raise "Tried to merge incompatible filters #{current_mod} and #{append_mod}"
    end

    left = Map.from_struct(left)
    right = Map.from_struct(right)
    merged = Map.merge(left, right)
    %Opts{opts | filter: struct!(current_mod, merged)}
  end

  defp merge_pagination(%Opts{pagination: nil} = opts, %Pagination{} = pagination) do
    sanity_check_pagination!(pagination)

    %Opts{opts | pagination: pagination}
  end

  defp merge_pagination(%Opts{pagination: %Pagination{} = left} = opts, %Pagination{} = right) do
    left = Map.from_struct(left)
    right = Map.from_struct(right)
    merged = Map.merge(left, right, fn _k, v1, v2 -> v2 || v1 end)
    pagination = struct!(Pagination, merged)

    sanity_check_pagination!(pagination)

    %Opts{opts | pagination: pagination}
  end

  defp pagination_valid?(%Pagination{} = pagination) do
    page_style? = not Enum.all?(pagination |> Map.take([:page, :page_size]) |> Map.values(), &is_nil/1)
    limit_style? = not Enum.all?(pagination |> Map.take([:start, :limit]) |> Map.values(), &is_nil/1)

    # page_style? XOR limit_style?
    (page_style? or limit_style?) and not (page_style? and limit_style?)
  end

  defp sanity_check_pagination!(%Pagination{} = pagination) do
    unless pagination_valid?(pagination) do
      raise """
      Don't mix page & start or page_size & limit. Use either page & page_size or start & limit
      """
    end
  end
end
