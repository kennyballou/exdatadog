defmodule Exdatadog.Search do
  @moduledoc """
  Search for metrics or hosts in DataDog
  """

  import Exdatadog

  @doc """
  Search for entities in the last 24 hours in DataDog

  Available entities to search for are:

  * `hosts`

  * `metrics`

  """
  @spec search(binary, Exdatadog.Client.t) :: Exdatadog.response
  def search(query, client) do
    get("api/v1/search", client, [q: query])
  end

end
