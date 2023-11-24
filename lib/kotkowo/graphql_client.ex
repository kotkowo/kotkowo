defmodule Kotkowo.StrapiClient do
  @moduledoc false
  use Rustler,
    otp_app: :kotkowo,
    crate: :strapiclient

  def list_cats(_is_dead \\ false, _is_adopted \\ nil, _limit \\ nil, _offset \\ nil),
    do: :erlang.nif_error(:nif_not_loaded)

  def list_adopted_cats(_limit \\ nil, _offset \\ nil), do: :erlang.nif_error(:nif_not_loaded)
  def list_adopted_cats_pages(_number \\ nil, _offset \\ nil), do: :erlang.nif_error(:nif_not_loaded)
  def list_announcements(_number \\ nil, _offset \\ nil), do: :erlang.nif_error(:nif_not_loaded)
  def get_announcement_list_pages(_number \\ nil, _offset \\ nil), do: :erlang.nif_error(:nif_not_loaded)
  def get_cat(_slug), do: :erlang.nif_error(:nif_not_loaded)
  def get_article_for_announcement(_announcement_id), do: :erlang.nif_error(:nif_not_loaded)
end
