defmodule KotkowoWeb.Layouts do
  @moduledoc false
  use KotkowoWeb, :html

  import KotkowoWeb.Components.Flashes
  import KotkowoWeb.Components.Sections
  import KotkowoWeb.Constants, only: [kotkowo_mail: 0]

  def links do
    [
      {"Aktualności", "/aktualnosci",
       [
         {"Z ostatniej chwili", "/aktualnosci/z-ostatniej-chwili"},
         {"Znalazły dom", "/aktualnosci/znalazly-dom"},
         {"Za tęczowym mostem", "/aktualnosci/za-teczowym-mostem"}
       ], []},
      {"Adopcja", ~p"/adopcja/szukaja-domu",
       [
         {"Szukają domu", ~p"/adopcja/szukaja-domu"},
         {"Zasady adopcji", ~p"/adopcja/zasady-adopcji"},
         {"Adoptuj wirtualnie kota", ~p"/adopcja/adopcja-wirtualna"}
       ], []},
      {"Zaginione/znalezione", ~p"/zaginione-znalezione",
       [
         {"Zaginione", ~p"/zaginione-znalezione/zaginione"},
         {"Znalezione", ~p"/zaginione-znalezione/znalezione"}
       ], []},
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
