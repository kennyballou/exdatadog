defmodule ExdatadogTest do
  @moduledoc """
  Provides tests for the Exdatadog module
  """
  use ExUnit.Case

  alias HTTPoison.Response
  import Exdatadog

  doctest Exdatadog

  setup_all do
    :meck.new(Poison, [:no_link])

    on_exit fn ->
      :meck.unload(Poison)
    end
  end

  test "auth_params using api_key" do
    assert auth_params(%{api_key: "1234"}) == [api_key: "1234"]
  end

  test "auth_params using api_key and app_key" do
    expected = [application_key: "abcd", api_key: "1234"]
    assert auth_params(%{api_key: "1234", app_key: "abcd"}) == expected
  end

  test "auth_params with no auth" do
    assert auth_params(%{}) == []
    assert auth_params(nil) == []
  end

  test "process_response with 200" do
    assert process_response(%Response{status_code: 200,
                                      headers: %{},
                                      body: "json"}) == {200, "json"}
    assert :meck.validate(Poison)
  end

  test "process_response with non-200" do
    assert process_response(%Response{status_code: 404,
                                      headers: %{},
                                      body: "json"}) == {404, "json"}

    assert :meck.validate(Poison)
  end

  test "process_resposne_body with nil body" do
    assert process_response_body("") == nil
  end

  test "process_response_body with content" do
    :meck.expect(Poison, :decode!, 1, :decoded_json)
    assert process_response_body("json") == :decoded_json
  end

  test "process_response with empty body" do
    assert process_response(%Response{status_code: 202,
                                      headers: %{},
                                      body: nil}) == {202, nil}
  end

end
