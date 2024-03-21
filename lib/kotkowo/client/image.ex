defmodule Kotkowo.Client.Image do
  @moduledoc false
  defstruct [:id, :name, :width, :height, :url, :mime, :alternative_text, :preview_url]

  @type t() :: %__MODULE__{
          id: String.t() | nil,
          name: String.t() | nil,
          width: pos_integer(),
          height: pos_integer(),
          url: String.t() | nil,
          mime: String.t() | nil,
          alternative_text: String.t() | nil,
          preview_url: String.t() | nil
        }
end
