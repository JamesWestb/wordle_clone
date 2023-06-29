import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :wordle_clone, WordleClone.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "wordle_clone_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :wordle_clone, WordleCloneWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "JU/jVJfC4hOSYavkbfq4KJTtPHndd/VPzRXpMKqcusNyPI6k4F7WYhx2n0E6xfuG",
  server: true

config :wordle_clone, sql_sandbox: true

config :wallaby,
  otp_app: :wordle_clone,
  screenshot_on_failure: true,
  driver: Wallaby.Chrome,
  chromedriver: [headless: false]

# In test we don't send emails.
config :wordle_clone, WordleClone.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
