defmodule KotkowoWeb.Layouts do
  @moduledoc false
  use KotkowoWeb, :html

  import KotkowoWeb.Components.Flashes
  import KotkowoWeb.Components.Sections

  @links [
    {"Aktualności", nil,
     [
       {"Z ostatniej chwili", "#"},
       {"Znalazły dom", "#"},
       {"Za tęczowym mostem", "#"}
     ], []},
    {"Adopcja", nil,
     [
       {"Szukają domu", "#"},
       {"Zasady adopcji", "#"},
       {"Adoptuj wirtualnie kota", "#"}
     ], []},
    {"Zaginione/znalezione", "#zaginione-znalezione", [], []},
    {"Jak pomóc", nil,
     [
       {"Przekaż nam 1% podatku", "#"},
       {"Wesprzyj nas finansowo", "#"},
       {"Przekaż rzeczy dla kotów", "#"},
       {"Zorganizuj zbiórkę", "#"},
       {"Załóż dom tymczasowy", "#"},
       {"Zapisz się na wolontariat", "#"}
     ], ["p-2", "bg-highlight"]},
    {"Porady", nil,
     [
       {"Czy to już czas na kota?", "#"},
       {"Przygotuj dom na kota", "#"},
       {"Jak opiekować się kotem?", "#"},
       {"Co robić, gdy znajdę kota?", "#"},
       {"Zachowanie kota", "#"}
     ], []},
    {"O nas", nil,
     [
       {"Historia fundacji", "#"},
       {"Partnerzy", "#"},
       {"Dokumenty", "#"}
     ], []}
  ]

  @spec links :: [KotkowoWeb.Components.Sections.link()]
  def links, do: @links

  embed_templates "layouts/*"
end
