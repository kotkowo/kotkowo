defmodule KotkowoWeb.PageController do
  use KotkowoWeb, :controller

  @home_meta %{title: "Strona główna", parent: nil, controller: __MODULE__, method: :home}
  def home_meta, do: @home_meta

  def home(conn, _params) do
    render(conn, :home, meta: @home_meta)
  end

  @help_meta %{
    title: "Jak pomóc?",
    parent: &__MODULE__.home_meta/0,
    controller: __MODULE__,
    method: :help
  }
  def help_meta, do: @help_meta

  def help(conn, _params) do
    render(conn, :help, meta: @help_meta)
  end

  @item_donation_meta %{
    title: "Przekaż rzeczy dla kotków",
    parent: &__MODULE__.help_meta/0,
    controller: __MODULE__,
    method: :help
  }
  def item_donation(conn, _params) do
    render(conn, :item_donation, meta: @item_donation_meta)
  end
end
