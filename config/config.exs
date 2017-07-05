# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :ace, Ace.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "z2yinNtptJRgygsiXI8uRPUx9XfaJMYecDFYKwAIZHCbW6lOH+yClLm5G06j32r5",
  render_errors: [view: Ace.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Ace.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

	# Configures Guardian's JWT
config :guardian, Guardian,
  allowed_algos: ["HS256"], # optional
  verify_module: Guardian.JWT,  # optional
  issuer: "Twin",
  ttl: { 30, :days },
  verify_issuer: true, # optional
  secret_key: "S3cr3tCann@tB3T@ld!",
  serializer: Ace.GuardianSerializer

config :bolt_sips, Bolt,
  hostname: 'localhost',
   basic_auth: [username: "neo4j", password: "Ultimate"],
  port: 7687,
  pool_size: 5,
  max_overflow: 1

#BrainTree Payment
config :braintree,
  environment: :sandbox,
  merchant_id: "vymz72rj5wkdfb3p",
  public_key:  "7b3sfkvmftfn4269",
  private_key: "f37447bd542536d4496b4e58632444d3"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
