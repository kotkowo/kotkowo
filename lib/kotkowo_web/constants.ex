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
  def kotkowo_zrzutka, do: "https://zrzutka.pl/sfmr6p"
  def kotkowo_messenger, do: "https://www.facebook.com/messages/t/100425863335655"
  def kotkowo_paypal, do: "https://www.paypal.com/donate/?hosted_button_id=QX8YAKQ4FFA5S"
  def adoption_agreement, do: "/documents/umowa_adopcyjna_2023.pdf"
  def cookie_policy, do: "#"
  def rodo_policy, do: "/documents/rodo.pdf"
  def privacy_policy, do: "/documents/privacy_policy.pdf"
  def krs, do: "0000345319"
  def nip, do: "9662018446"
  def regon, do: "20032337500000"
  def swift_bic, do: "EBOSPLPWXXX"
  def bank_account_number, do: "87 1540 1216 2054 4458 2306 0001"
  def iban, do: "PL #{bank_account_number()}"
  def bank, do: "BOŚ SA O. w Białymstoku"
  def kotkowo_address, do: "al. Piłsudskiego 26/31"
  def postal_code, do: "15-446 Białystok"
  def opp_report_base, do: "https://sprawozdaniaopp.niw.gov.pl/"
  def fundation_statute, do: "/documents/statut.pdf"

  def adoption_form,
    do: "https://docs.google.com/forms/d/e/1FAIpQLSfQBZ0CHZlXGSGv32HG0mYqQHCskryBlYKUKc3SiHk2cBY-Eg/viewform"

  def partnership_form,
    do: "https://docs.google.com/forms/d/e/1FAIpQLSetpNAlTcbaBQLM9pir_ZlAeqpv2rNfrjfFT96bTnHPtPZV6w/viewform"

  def volunteer_form,
    do: "https://docs.google.com/forms/d/e/1FAIpQLScLwoP7x57Yjkx1PVpw0qSR9RR-L3iQNAR5FT2R5tetwRWk5w/viewform"
end
