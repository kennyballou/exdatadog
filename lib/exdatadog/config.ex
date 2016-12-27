defmodule Exdatadog.Config do
  @moduledoc """
  Provides helper functions for interacting with Application variables
  """

  def get_env_var(app, key, default \\ nil) do
    app
    |> Application.get_env(key, default)
    |> case do
      {:system, env_key} -> System.get_env(env_key)
      env_var -> env_var
    end
  end

end
