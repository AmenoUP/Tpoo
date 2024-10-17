import Config

# Note we also include the path to a cache manifest
# containing the digested version of static files. This
# manifest is generated by the `mix assets.deploy` task,
# which you should run after static files are built and
# before starting your production server.
config :tpoo, TpooWeb.Endpoint, cache_static_manifest: "priv/static/cache_manifest.json"

# Configures Swoosh API Client
config :swoosh, api_client: Swoosh.ApiClient.Finch, finch_name: Tpoo.Finch

# Disable Swoosh Local Memory Storage
config :swoosh, local: false

# Do not print debug messages in production
config :logger, level: :info

# Runtime production configuration, including reading
# of environment variables, is done on config/runtime.exs.

config :tpoo, Tpoo.Repo,
  username: "tpoo_dev_user",
  password: "m9NZwgZaeNqanCsZPPAuYCh9SjEHMwju",
  database: "tpoo_dev",
  hostname: "dpg-cs8c5oe8ii6s73c82bbg-a.frankfurt-postgres.render.com",
  ssl: true,
  ssl_opts: [verify: :verify_none],
  pool_size: 10
