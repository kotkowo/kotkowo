defmodule Kotkowo.StrapiClient do
  use Rustler,
    otp_app: :kotkowo,
    crate: :strapiclient

  def list_cats(), do: :erlang.nif_error(:nif_not_loaded)
  def get_cat(_slug), do: :erlang.nif_error(:nif_not_loaded)
  # def random_org_int(_arg1, _arg2), do: :erlang.nif_error(:nif_not_loaded)
  # def random_result_to_string(_arg1), do: :erlang.nif_error(:nif_not_loaded)
end
