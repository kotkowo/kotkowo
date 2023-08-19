import Config

# For production, don't forget to configure the url host
# to something meaningful, Phoenix uses this information
# when generating URLs.

# Note we also include the path to a cache manifest
# containing the digested version of static files. This
# manifest is generated by the `mix phx.digest` task,
# which you should run after static files are built and
# before starting your production server.
config :kotkowo, KotkowoWeb.Endpoint,
  cache_static_manifest: "priv/static/cache_manifest.json",
  url: [host: System.get_env("HOSTNAME"), port: 80],
  secret_key_base: System.get_env("SECRET_KEY_BASE")

config :kotkowo, Kotkowo.Repo, url: System.get_env("DATABASE_URL")

# Do not print debug messages in production
config :logger, level: :info

# Runtime production configuration, including reading
# of environment variables, is done on config/runtime.exs.
