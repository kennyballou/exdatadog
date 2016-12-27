defmodule Exdatadog do
  @moduledoc """
  HTTPoison Client for exdatadog
  """
  use HTTPoison.Base

  alias Exdatadog.Client
  alias HTTPoison.Response

  @user_agent [{"user-agent", "exdatadog"}]

  @type response :: {integer, any} | map

  @spec process_response_body(binary) :: map
  def process_response_body(""), do: nil
  def process_response_body(body), do: Poison.decode!(body)

  @spec process_response(HTTPoison.Response.t) :: response
  def process_response(%Response{status_code: status_code, body: body}) do
    {status_code, body}
  end

  def post(path, client, body) do
    _request(:post, url(client, path), client.auth, body)
  end

  def get(path, client, params \\ [], _ \\ []) do
    url =
      client
      |> url(path)
      |> add_params_to_url(params)

    _request(:get, url, client.auth)

  end

  def _request(method, url, auth, body \\ "") do
    json_request(method,
                 add_params_to_url(url, auth_params(auth)),
                 body,
                 @user_agent)
  end

  def json_request(method, url, body \\ "", headers \\ [], options \\ []) do
    raw_request(method, url, Poison.encode!(body), headers, options)
  end

  def raw_request(method, url, body \\ "", headers \\ [], options \\ []) do
    method
    |> request!(url, body, headers, options)
    |> process_response
  end

  @spec url(Exdatadog.Client.t, binary) :: binary
  defp url(_client = %Client{endpoint: endpoint}, path) do
    endpoint <> path
  end

  @doc """
  Take an existing URI and add addition parameters, merging as necessary

  ## Examples
      iex> add_params_to_url("http://example.com/wat", [])
      "http://example.com/wat"
      iex> add_params_to_url("http://example.com/wat", [q: 1])
      "http://example.com/wat?q=1"
      iex> add_params_to_url("http://example.com/wat", [q: 1, t: 2])
      "http://example.com/wat?q=1&t=2"
      iex> add_params_to_url("http://example.com/wat", %{q: 1, t: 2})
      "http://example.com/wat?q=1&t=2"
      iex> add_params_to_url("http://example.com/wat?q=1&t=2", [])
      "http://example.com/wat?q=1&t=2"
      iex> add_params_to_url("http://example.com/wat?q=1", [t: 2])
      "http://example.com/wat?q=1&t=2"
      iex> add_params_to_url("http://example.com/wat?q=1", [q: 3, t: 2])
      "http://example.com/wat?q=3&t=2"
      iex> add_params_to_url("http://example.com/wat?q=1&s=4", [q: 3, t: 2])
      "http://example.com/wat?q=3&s=4&t=2"
      iex> add_params_to_url("http://example.com/wat?q=1&s=4", %{q: 3, t: 2})
      "http://example.com/wat?q=3&s=4&t=2"

  """
  @spec add_params_to_url(binary, list) :: binary
  def add_params_to_url(url, params) do
    url
    |> URI.parse
    |> merge_uri_params(params)
    |> to_string
  end

  defp merge_uri_params(uri, []), do: uri
  defp merge_uri_params(%URI{query: nil} = uri, params)
      when is_list(params) or is_map(params) do
    uri
    |> Map.put(:query, URI.encode_query(params))
  end
  defp merge_uri_params(%URI{} = uri, params)
      when is_list(params) or is_map(params) do
    uri
    |> Map.update!(:query, fn q ->
      q
      |> URI.decode_query
      |> Map.merge(param_list_to_map_with_string_keys(params))
      |> URI.encode_query
    end)
  end

  defp param_list_to_map_with_string_keys(list)
      when is_list(list) or is_map(list) do
    for {key, value} <- list, into: Map.new do
      {"#{key}", value}
    end
  end

  def auth_params(%{api_key: api_key, app_key: app_key}) do
    [application_key: app_key, api_key: api_key]
  end
  def auth_params(%{api_key: api_key}) do
    [api_key: api_key]
  end
  def auth_params(_), do: []

end
