# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :star_wars,
  namespace: StarWars,
  ecto_repos: [StarWars.Repo],
  generators: [binary_id: true],
  integration_source: :star_wars_public_api

# Configures the endpoint
config :star_wars, StarWarsAPI.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: StarWarsAPI.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: StarWarsAPI.PubSub,
  live_view: [signing_salt: "GHNBnwIx"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Tell logger to load a LoggerFileBackend processes
config :logger,
  backends: [
    :console,
    {LoggerFileBackend, :info_log},
    {LoggerFileBackend, :error_log}
  ]

# Configuration for the {LoggerFileBackend, :info_log} backend
config :logger, :info_log,
  path: "logs/info.log",
  level: :info,
  metadata: [:module, :function_name]

# Configuration for the {LoggerFileBackend, :error_log} backend
config :logger, :error_log,
  path: "logs/error.log",
  level: :error,
  metadata: [:module, :function_name]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
