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

    scope "/adopcja" do
      live "/szukaja-domu/:slug", AdoptionLive.Show
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
