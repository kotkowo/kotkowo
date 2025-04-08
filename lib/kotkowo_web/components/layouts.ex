defmodule KotkowoWeb.Layouts do
  @moduledoc false
  use KotkowoWeb, :html

  import KotkowoWeb.Components.Flashes
  import KotkowoWeb.Components.Sections
  import KotkowoWeb.Constants, only: [kotkowo_mail: 0]

  alias Kotkowo.Client.Paged

  require Logger

  defp advice_links({:ok, %Paged{items: items}}) do
    Enum.map(items, fn %Kotkowo.Client.Advice{title: title, id: id} -> {title, ~p"/porady/#{id}"} end)
  end

  defp advice_links({:error, err}) do
    err |> inspect() |> Logger.error()
    []
  end

  defp advice_links do
    Kotkowo.AdviceHandler |> GenServer.call(:get_advice) |> advice_links()
  end

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
         {"Zasady adopcji", ~p"/adopcja/zasady-adopcji"}
         # {"Adoptuj wirtualnie kota", ~p"/adopcja/adopcja-wirtualna"}
       ], []},
      {"Zaginione/znalezione", ~p"/zaginione-znalezione",
       [
         {"Zaginione", ~p"/zaginione-znalezione/zaginione"},
         {"Znalezione", ~p"/zaginione-znalezione/znalezione"}
       ], []},
      {"Jak pomóc", ~p"/pomoc",
       [
         {"Przekaż nam 1,5% podatku", ~p"/pomoc/przekaz-nam-podatek"},
         {"Wesprzyj nas finansowo", ~p"/pomoc/wsparcie-finansowe"},
         {"Przekaż rzeczy dla kotów", ~p"/pomoc/przekaz-rzeczy-dla-kotkow"},
         {"Zorganizuj zbiórkę", ~p"/pomoc/zorganizuj-zbiorke-rzeczowa"},
         {"Załóż dom tymczasowy", ~p"/pomoc/stworz-dom-tymczasowy"},
         {"Zapisz się na wolontariat", ~p"/pomoc/zapisz-sie-na-wolontariat"}
       ], ["p-2", "bg-highlight"]},
      {"Porady", ~p"/porady", advice_links(), []},
      {"O nas", ~p"/o-nas/o-fundacji",
       [
         {"O fundacji", ~p"/o-nas/o-fundacji"},
         {"Historia Kotkowa", ~p"/o-nas/historia-kotkowa"},
         {"Partnerzy", ~p"/o-nas/partnerzy"},
         {"Media o nas", ~p"/o-nas/media-o-nas"},
         {"Dokumenty", ~p"/o-nas/dokumenty"},
         {"FAQ", ~p"/o-nas/faq"}
       ], []}
    ]
  end

  def plausible_script_endpoint do
    Application.get_env(:kotkowo, :plausible)[:script_endpoint]
  end

  embed_templates "layouts/*"
end
