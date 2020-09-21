defmodule TrafficLightWeb.Router do
  use TrafficLightWeb, :router

  import Phoenix.LiveDashboard.Router
  import Plug.BasicAuth

  alias TrafficLightWeb.Plugs.WebhookToken

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {TrafficLightWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :webhooks do
    plug :accepts, ["json"]
    plug WebhookToken, token: Application.get_env(:traffic_light, :ci_secret)
  end

  pipeline :dashboard do
    plug :basic_auth, Application.get_env(:traffic_light, :dashboard_auth)
  end

  scope "/", TrafficLightWeb do
    pipe_through :browser

    live "/", PageLive, :index
  end

  scope "/", TrafficLightWeb do
    pipe_through :api

    resources "/lights", LightSettingController, only: [:show], singleton: true
  end

  scope "/webhooks", TrafficLightWeb do
    pipe_through :webhooks

    resources "/codeship", Webhook.CodeshipController, only: [:create], singleton: true
    resources "/github", Webhook.GithubController, only: [:create], singleton: true
  end

  scope "/" do
    pipe_through :browser
    pipe_through :dashboard
    live_dashboard "/dashboard", metrics: TrafficLightWeb.Telemetry
  end
end
