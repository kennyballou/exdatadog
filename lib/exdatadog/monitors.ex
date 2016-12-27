defmodule Exdatadog.Monitors do
  @moduledoc """
  Module for interacting with Datadog Monitors
  """

  import Exdatadog

  @doc """
  Request the details of a monitor
  """
  @spec details(integer, List.t, Exdatadog.Client.t) :: Exdatadog.response
  def details(id, group_states \\ [], client)
  def details(id, [], client) do
    get("api/v1/monitor/#{id}", client)
  end
  def details(id, group_states, client) do
    get("api/v1/monitor/#{id}",
        client,
        group_states: Enum.join(group_states, ","))
  end


end
