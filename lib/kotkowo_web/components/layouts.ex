defmodule KotkowoWeb.Layouts do
  use KotkowoWeb, :html

  @type nested_link :: {String.t(), String.t()}
  @type css_classes :: [String.t()]
  @type link :: {String.t(), String.t() | nil, [nested_link()], css_classes()}

  @contact_email "kotkowo@email.com"
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

  @spec links :: [link()]
  def links, do: @links

  @spec contact_email :: String.t()
  def contact_email, do: @contact_email

  embed_templates "layouts/*"
end
