# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

# Configures the endpoint
config :traffic_light, TrafficLightWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "xmvVgosMQXEpSCIiaIM1jbu89Vw+KFyD8v675UJmettlWbebOMjh6mnNbPWD+96t",
  render_errors: [view: TrafficLightWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: TrafficLight.PubSub,
  live_view: [signing_salt: "zyPux95O"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
