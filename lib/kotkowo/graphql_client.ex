defmodule Kotkowo.StrapiClient do
  @moduledoc false
  use Rustler,
    otp_app: :kotkowo,
    crate: :strapiclient

  def list_cats, do: :erlang.nif_error(:nif_not_loaded)
  def list_announcements, do: :erlang.nif_error(:nif_not_loaded)
  def get_cat(_slug), do: :erlang.nif_error(:nif_not_loaded)
end
