defmodule KotkowoWeb.Constants do
  @moduledoc false
  @downloadable_assets [
    "kotkowo_logo_black.svg",
    "kotkowo_logo.svg"
  ]
  def kotkowo_assets, do: @downloadable_assets
  def kotkowo_mail, do: "fundacja.kotkowo@gmail.com"
  def kotkowo_github, do: "https://github.com/kotkowo/kotkowo"
  def kotkowo_url, do: "https://kotkowo.ravensiris.xyz"
  def kotkowo_facebook, do: "https://www.facebook.com/kotkowo"
  def kotkowo_zrzutka, do: "#"
  def kotkowo_messenger, do: "#"
  def adoption_form, do: "#"
  def kotkowo_paypal, do: "#"
  def pre_adoption_form, do: "#"
  def partnership_form, do: "#"
  def volunteer_form, do: "#"
  def temporary_shelter_form, do: "#"
  def adoption_agreement, do: "#"
  def cookie_policy, do: "#"
  def rodo_policy, do: "#"
  def privacy_policy, do: "#"
  def krs, do: "0000345319"
  def nip, do: "9662018446"
  def regon, do: "20032337500000"
  def swift_bic, do: "EBOSPLPWXXX"
  def bank_account_number, do: "87 1540 1216 2054 4458 2306 0001"
  def iban, do: "PL #{bank_account_number()}"
  def bank, do: "BOŚ SA O. w Bialymstoku"
  def kotkowo_address, do: "al. Piłsudskiego 26/31"
  def postal_code, do: "15-446 Białystok"
end
