defmodule Kotkowo.StrapiClient do
  @moduledoc false
  use Rustler,
    otp_app: :kotkowo,
    crate: :strapiclient

  def list_cats, do: :erlang.nif_error(:nif_not_loaded)
  def list_announcements(_number \\ nil, _offset \\ nil), do: :erlang.nif_error(:nif_not_loaded)
  def get_cat(_slug), do: :erlang.nif_error(:nif_not_loaded)
  def get_article(_announcement_id), do: :erlang.nif_error(:nif_not_loaded)
end
