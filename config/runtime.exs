import Config

strapi_endpoint =
  System.get_env("STRAPI_ENDPOINT") ||
    raise """
    environment variable STRAPI_ENDPOINT is missing.
    """

plausible_script_endpoint = System.get_env("PLAUSIBLE_SCRIPT_ENDPOINT")
plausible_key = System.get_env("PLAUSIBLE_KEY")
plausible_url = System.get_env("PLAUSIBLE_URL")
host = System.get_env("PHX_HOST")

config :kotkowo, :strapi, endpoint: strapi_endpoint

config :kotkowo, :plausible,
  script_endpoint: plausible_script_endpoint,
  url: plausible_url,
  key: plausible_key,
  domain: host

if System.get_env("PHX_SERVER") do
  config :kotkowo, KotkowoWeb.Endpoint, server: true
end

if config_env() == :prod do
  if is_nil(host), do: raise("PHX_HOST is missing")

  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  port = String.to_integer(System.get_env("PORT") || "4000")

  config :kotkowo, KotkowoWeb.Endpoint,
    url: [host: host, port: 443, scheme: "https"],
    http: [
      ip: {0, 0, 0, 0, 0, 0, 0, 0},
      port: port
    ],
    secret_key_base: secret_key_base

  config :sentry,
    dsn: System.get_env("SENTRY_DSN"),
    environment_name: config_env(),
    included_environments: [:prod],
    enable_source_code_context: true,
    root_source_code_paths: [File.cwd!()]
end
