defmodule KotkowoWeb.Router do
  use KotkowoWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {KotkowoWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", KotkowoWeb do
    pipe_through :browser

    live "/", HomeLive.Index

    scope "/pomoc" do
      live "/", HelpLive.Index
      live "/przekaz-nam-podatek", HelpLive.TaxDonation
      live "/przekaz-rzeczy-dla-kotkow", HelpLive.ItemDonation
      live "/wsparcie-finansowe", HelpLive.FinancialAid
      live "/zorganizuj-zbiorke-rzeczowa", HelpLive.Collection
      live "/stworz-dom-tymczasowy", HelpLive.TemporaryHome
      live "/zapisz-sie-na-wolontariat", HelpLive.Volunteer
    end

    scope "/adopcja" do
      live "/szukaja-domu/:slug", AdoptionLive.Show
      live "/szukaja-domu", AdoptionLive.LookingForNewHome
      live "/zasady-adopcji", AdoptionLive.AdoptionRules
      live "/adopcja-wirtualna", AdoptionLive.VirtualAdoption
    end

    scope "/zaginione-znalezione" do
      live "/", LostAndFoundLive.Index
      live "/znalezione", LostAndFoundLive.Found

      scope "/zaginione" do
        live "/", LostAndFoundLive.Lost
        live "/:slug", LostAndFoundLive.Lost
      end
    end

    scope "/aktualnosci" do
      live "/", NewsLive.Index
      live "/znalazly-dom", NewsLive.FoundHome
      live "/za-teczowym-mostem", NewsLive.PassedAway

      scope "/z-ostatniej-chwili" do
        live "/", AnnouncementsLive.LatestNews
        live "/wszystkie", AnnouncementsLive.AllNews
        live "/:article_id", AnnouncementsLive.NewsArticle
      end
    end
  end

  if Application.compile_env(:kotkowo, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: KotkowoWeb.Telemetry
    end
  end
end
