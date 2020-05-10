use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :traffic_light, TrafficLightWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Redis connection data
config :traffic_light, :redis, url: "redis://localhost"

# The mode the traffic light should be operated in
config :traffic_light, :light_mode, "public"

# The secret token that allows the CI webhook to update the lights
config :traffic_light, :ci_secret, "MY-SECRET-CI-TOKEN"
