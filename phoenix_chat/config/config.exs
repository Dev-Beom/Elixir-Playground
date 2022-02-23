# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :phoenix_chat,
  ecto_repos: [PhoenixChat.Repo]

# Configures the endpoint
config :phoenix_chat, PhoenixChatWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "c4weZdGw3zmFbTNDmAA7zDV4jpmHS9Lc8W3P5tw0RzPPvWmEL9LMfnWovEUlBNCE",
  render_errors: [view: PhoenixChatWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: PhoenixChat.PubSub,
  live_view: [signing_salt: "X91TCU9t"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
