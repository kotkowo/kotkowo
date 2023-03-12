defmodule KotkowoWeb.Layouts do
  @moduledoc false
  use KotkowoWeb, :html

  import KotkowoWeb.Components.Flashes
  import KotkowoWeb.Components.Sections

  @spec links :: [KotkowoWeb.Components.Sections.link()]
  def links do
    [
      {"Aktualności", nil,
       [
         {"Z ostatniej chwili", "#"},
         {"Znalazły dom", "#"},
         {"Za tęczowym mostem", "#"}
       ], []},
      {"Adopcja", nil,
       [
         {"Szukają domu", ~p"/adopcja/szukaja-domu"},
         {"Zasady adopcji", "#"},
         {"Adoptuj wirtualnie kota", "#"}
       ], []},
      {"Zaginione/znalezione", "#zaginione-znalezione", [], []},
      {"Jak pomóc", ~p"/pomoc",
       [
         {"Przekaż nam 1,5% podatku", "/pomoc/przekaz-nam-podatek"},
         {"Wesprzyj nas finansowo", ~p"/pomoc/wsparcie-finansowe"},
         {"Przekaż rzeczy dla kotów", ~p"/pomoc/przekaz-rzeczy-dla-kotkow"},
         {"Zorganizuj zbiórkę", ~p"/pomoc/zorganizuj-zbiorke-rzeczowa"},
         {"Załóż dom tymczasowy", ~p"/pomoc/stworz-dom-tymczasowy"},
         {"Zapisz się na wolontariat", ~p"/pomoc/zapisz-sie-na-wolontariat"}
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
  end

  embed_templates "layouts/*"
end
