defmodule Exdatadog.Metrics do
  @moduledoc """
  Metrics functions for DataDog
  """
  import Exdatadog

  @doc """
  Return active metrics between from given time to now

  Required parameter: `from`, seconds since unix epoch
  """
  @spec metrics(integer, Exdatadog.Client.t) :: Exdatadog.response
  def metrics(from, client) when is_integer(from) do
    get("api/v1/metrics", client, from: from)
  end

  @doc """
  Post time-series data to Datadog
  """
  @spec post_series(map, Exdatadog.Client.t) :: Exdatadog.response
  def post_series(series, client) when is_map(series) do
    post("api/v1/series", client, series)
  end

  @doc """
  Query Metrics for any time period
  """
  @spec query(integer, integer, binary, Exdatadog.Client.t) ::
    Exdatadog.response
  def query(from, to, query, client) do
    get("api/v1/query", client, [from: from, to: to, query: query])
  end

end
