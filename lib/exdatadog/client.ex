defmodule Exdatadog.Client do
  @moduledoc """
  Datadog Client record for endpoint and authentication data
  """

  import Exdatadog.Config, only: [get_env_var: 2]

  defstruct auth: nil, endpoint: "https://app.datadoghq.com/"

  @type auth :: %{api_key: binary, app_key: binary} | %{api_key: binary}
  @type t :: %__MODULE__{auth: auth, endpoint: binary}

  @spec new() :: t
  def new() do
    auth = %{api_key: get_env_var(:exdatadog, :api_key),
             app_key: get_env_var(:exdatadog, :app_key)}
    %__MODULE__{auth: auth}
  end

  @spec new(auth) :: t
  def new(auth), do: %__MODULE__{auth: auth}

  @spec new(auth, binary) :: t
  def new(auth, endpoint) do
    endpoint = if String.ends_with?(endpoint, "/") do
      endpoint
    else
      endpoint <> "/"
    end
    %__MODULE__{auth: auth, endpoint: endpoint}
  end

end
