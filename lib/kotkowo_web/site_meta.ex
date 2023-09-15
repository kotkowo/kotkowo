defmodule KotkowoWeb.SiteMeta do
  defmacro live_with_meta(path, module, opts \\ []) do
    path = Macro.expand(path, __CALLER__)
    module = Macro.expand(module, __CALLER__)
    opts = Macro.expand(opts, __CALLER__)

    metadata = Keyword.get(opts, :metadata, %{})
    site_meta = __MODULE__.meta(module, path)
    metadata = Map.put(metadata, :site_meta, site_meta)
    opts = Keyword.put(opts, :metadata, metadata)

    quote bind_quoted: [path: path, module: module, opts: Macro.escape(opts)] do
      live path, module, opts
    end
  end

  def meta(:home) do
    %{title: "Strona główna", parent: nil, controller: __MODULE__, method: :home}
  end

  def meta(:help) do
    %{
      title: "Jak pomóc?",
      parent: :home,
      controller: __MODULE__,
      method: :help
    }
  end

  def meta(:item_donation) do
    %{
      title: "Przekaż rzeczy dla kotków",
      parent: :help,
      controller: __MODULE__,
      method: :item_donation
    }
  end

  def meta(:collection) do
    %{
      title: "Zorganizuj zbiórkę rzeczową",
      parent: :help,
      controller: __MODULE__,
      method: :collection
    }
  end

  def meta(:temporary_home) do
    %{
      title: "Stwórz dom tymczasowy",
      parent: :help,
      controller: __MODULE__,
      method: :temporary_home
    }
  end

  def meta(:volunteer) do
    %{
      title: "Zapisz się na wolontariat",
      parent: :help,
      controller: __MODULE__,
      method: :volunteer
    }
  end

  def meta(:tax_donation) do
    %{
      title: "Przekaż nam 1,5% podatku",
      parent: :help,
      controller: __MODULE__,
      method: :volunteer
    }
  end

  def meta(:financial_aid) do
    %{
      title: "Wsparcie finansowe",
      parent: :help,
      controller: __MODULE__,
      method: :financial_aid
    }
  end

  def meta(:adoption) do
    %{
      title: "Adopcja",
      parent: :home,
      controller: __MODULE__,
      method: nil
    }
  end

  def meta(:looking_for_new_home) do
    %{
      title: "Szukają domu",
      parent: :adoption,
      controller: __MODULE__,
      method: :looking_for_new_home
    }
  end

  def meta(KotkowoWeb.AdoptionLive.Cat, path) do
    %{
      title: ":cat-name:",
      parent: :looking_for_new_home,
      path: path
    }
  end
end
