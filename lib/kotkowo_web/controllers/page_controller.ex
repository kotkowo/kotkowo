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
    method: :item_donation
  }
  def item_donation_meta, do: @item_donation_meta

  def item_donation(conn, _params) do
    render(conn, :item_donation, meta: @item_donation_meta)
  end

  @collection_meta %{
    title: "Zorganizuj zbiórkę rzeczową",
    parent: &__MODULE__.help_meta/0,
    controller: __MODULE__,
    method: :collection
  }
  def collection_meta, do: @collection_meta

  def collection(conn, _params) do
    render(conn, :collection, meta: @collection_meta)
  end

  @temporary_home_meta %{
    title: "Stwórz dom tymczasowy",
    parent: &__MODULE__.help_meta/0,
    controller: __MODULE__,
    method: :temporary_home
  }
  def temporary_home_meta, do: @temporary_home_meta

  def temporary_home(conn, _params) do
    render(conn, :temporary_home, meta: @temporary_home_meta)
  end

  @volunteer_meta %{
    title: "Zapisz się na wolontariat",
    parent: &__MODULE__.help_meta/0,
    controller: __MODULE__,
    method: :volunteer
  }
  def volunteer_meta, do: @volunteer_meta

  def volunteer(conn, _params) do
    render(conn, :volunteer, meta: @volunteer_meta)
  end
end
