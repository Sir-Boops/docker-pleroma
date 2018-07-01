use Mix.Config

config :pleroma, Pleroma.Web.Endpoint,
   url: [host: "test", scheme: "http", port: 80],
   secret_key_base: "lel"

config :pleroma, :instance,
  name: "test",
  email: "test@test.net",
  limit: 5000,
  registrations_open: true,
  dedupe_media: false

config :pleroma, :media_proxy,
  enabled: false,
  redirect_on_failure: true
  #base_url: "https://cache.pleroma.social"

# Configure your database
config :pleroma, Pleroma.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "pleroma",
  password: "pleroma",
  database: "pleroma_dev",
  hostname: "postgres",
  pool_size: 10

config :pleroma, :http,
  proxy_url: "privoxy:8118"
