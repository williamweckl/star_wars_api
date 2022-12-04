import Config

config :star_wars,
  integration_source: :mock

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :star_wars, StarWars.Repo,
  username: "postgres",
  password: "postgres",
  hostname: System.get_env("POSTGRES_HOST", "localhost"),
  database: "star_wars_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :star_wars, StarWarsAPI.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "hPMccC5nxUCzbAg+PEEP0WRl1X5kTpjCak0sLGlFEauQoBeEcZE5gCsjrvVkLXz6",
  server: false,
  admin_password: "admin",
  rate_limit_enabled: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configuration for the {LoggerFileBackend, :info_log} backend
config :logger, :info_log, path: "logs/test/info.log"

# Configuration for the {LoggerFileBackend, :error_log} backend
config :logger, :error_log, path: "logs/test/error.log"

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
