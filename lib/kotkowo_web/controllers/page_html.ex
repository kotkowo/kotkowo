defmodule KotkowoWeb.PageHTML do
  @moduledoc false
  use KotkowoWeb, :html

  import KotkowoWeb.Components.Cards
  import KotkowoWeb.Components.Buttons

  embed_templates "page_html/*"
end
