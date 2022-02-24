# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :phoenix_exq,
  ecto_repos: [PhoenixExq.Repo]

# Configures the endpoint
config :phoenix_exq, PhoenixExqWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "FUTQr5eDUcO8+wwZlB2wut1ZSveSRHx2G1vKrmFFPu16kKBd+/Z2xiwXggJ9ozNA",
  render_errors: [view: PhoenixExqWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: PhoenixExq.PubSub,
  live_view: [signing_salt: "omSte6bc"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :exq,
  name: Exq,
  host: "127.0.0.1",
  port: "6379",
  namespace: "exq",
  concurrency: 10000,
  queues: ["jobs"]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
