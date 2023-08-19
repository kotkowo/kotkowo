import Config

config :kotkowo, KotkowoWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "6dBIiICVMpVn8EvfDYLHAqSA6RTBssR69YtmYHdlOE2N3MrU5Ksc4CQYSUPn7pGZ",
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
