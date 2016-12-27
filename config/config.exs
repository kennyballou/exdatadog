use Mix.Config

config :exdatadog,
  api_key: {:system, "DATADOG_API_KEY"},
  app_key: {:system, "DATADOG_APP_KEY"}

import_config "#{Mix.env}.exs"
