defmodule Exdatadog.Client.Test do
  @moduledoc """
  Provides Tests for the Exdatadog.Client module
  """
  use ExUnit.Case, async: false

  @endpoint "https://app.datadoghq.com/"

  alias Exdatadog.Client

  test "can create new client" do
    expected = %Client{endpoint: @endpoint, auth: %{api_key: "1234",
                                                    app_key: "abcd"}}
    assert Client.new() == expected
  end

  test "can create new client with api auth" do
    actual = Client.new(%{api_key: "1234"})
    assert actual == %Client{endpoint: @endpoint, auth: %{api_key: "1234"}}
  end

  test "can create new client with api and app auth" do
    actual = Client.new(%{api_key: "1234", app_key: "abcd"})
    assert actual == %Client{endpoint: @endpoint, auth: %{api_key: "1234",
                                                          app_key: "abcd"}}
  end

  test "can create new client with auth and custom endpoint" do
    actual = Client.new(%{api_key: "1234"}, "https://test.datadoghq.com/")
    assert actual == %Client{endpoint: "https://test.datadoghq.com/",
                             auth: %{api_key: "1234"}}
  end

  test "trailing / appended to endpoint without" do
    actual = Client.new(nil, "https://test.datadoghq.com")
    assert actual == %Client{endpoint: "https://test.datadoghq.com/", auth: nil}
  end

end
