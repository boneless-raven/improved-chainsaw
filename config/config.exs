# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :hnet,
  ecto_repos: [Hnet.Repo]

# Configures the endpoint
config :hnet, Hnet.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "LYEabS/9S6gLOoS/2IEu03CSXd/W0XTZ0gDmxMNga/GW4aqwrMyMe4/kFwla5myY",
  render_errors: [view: Hnet.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Hnet.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
