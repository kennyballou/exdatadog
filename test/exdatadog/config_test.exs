defmodule Exdatadog.Config.Test do
  @moduledoc """
  Provides tests for Exdatadog.Config
  """
  use ExUnit.Case

  import Exdatadog.Config

  setup_all do
    System.put_env("TEST_VAR", "BAR")
    Application.put_env(:test_app, :test_key, {:system, "TEST_VAR"})
    Application.put_env(:test_app, :test_foo, "FOO")

    on_exit fn ->
      System.delete_env("TEST_VAR")
      Application.delete_env(:test_app, :test_key)
      Application.delete_env(:test_app, :test_foo)
    end

  end

  test "can read variable from application settings" do
    assert get_env_var(:test_app, :test_foo) == "FOO"
  end

  test "can read environment variables for settings" do
    assert get_env_var(:test_app, :test_key) == "BAR"
  end

end
