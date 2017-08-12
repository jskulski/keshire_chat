# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :keshire_chat,
  ecto_repos: [KeshireChat.Repo]

# Configures the endpoint
config :keshire_chat, KeshireChatWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "W6yGRihJPqR2ak8aFCXx4cltC5GbPxkh5kkljmUT3NGfL8RWjpbQZFSEtnVywB8F",
  render_errors: [view: KeshireChatWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: KeshireChat.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
