defmodule Kotkowo.Client do
  @moduledoc false
  use Rustler, otp_app: :kotkowo, crate: :client

  alias Kotkowo.Client.Cat
  alias Kotkowo.Client.Opts
  alias Kotkowo.Client.Pagination

  def list_cats(_options \\ %Opts{}), do: :erlang.nif_error(:nif_not_loaded)

  def new(opts \\ [])

  def new(opts) when is_list(opts) do
    Enum.reduce(opts, %Opts{}, &parse_option/2)
  end

  def new(opt), do: new([opt])

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

  defp parse_option({:cat, filter}, %Opts{} = acc), do: parse_option(struct!(Cat.Filter, filter), acc)
  defp parse_option({:filter, filter}, %Opts{} = acc), do: parse_option(filter, acc)

  defp parse_option(%Cat.Filter{} = filter, %Opts{} = acc) do
    merge_filter(acc, filter)
  end

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
