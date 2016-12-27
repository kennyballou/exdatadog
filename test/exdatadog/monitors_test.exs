defmodule Exdatadog.Monitors.Test do
  @moduledoc """
  Tests Exdatadog.Monitors
  """
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  @cassette_dir "test/fixture/vcr_cassettes/monitors"

  alias Exdatadog.Client
  import Exdatadog.Monitors

  doctest Exdatadog.Monitors

  @lint {Credo.Check.Design.AliasUsage, false}
  setup_all do
    ExVCR.Config.cassette_library_dir(@cassette_dir)
  end

  test "can get montior details" do
    client = Client.new()
    expected = {200,
      %{"created" => "2015-12-18T16:34:14.014039+00:00",
        "id" => 91_879,
        "message" => "We may need to add web hosts if this is consistently high.",
        "modified" => "2015-12-18T16:34:14.014039+00:00",
        "multi" => false,
        "name" => "Bytes received on host0",
        "options" => %{"notify_audit" => false,
                       "notify_no_data" => false,
                       "silenced" => %{}},
        "org_id" => 1499,
        "query" => "avg(last_1h):sum:system.net.bytes_rcvd{host:host0} > 100",
        "type" => "metric alert"
    }}

    use_cassette "details" do
      assert details(91_879, client) == expected
    end
  end

  test "can get monitor details with group_states" do
    client = Client.new()
    expected = {200,
      %{"created" => "2015-12-18T16:34:14.014039+00:00",
        "id" => 91_879,
        "message" => "We may need to add web hosts if this is consistently high.",
        "modified" => "2015-12-18T16:34:14.014039+00:00",
        "multi" => false,
        "name" => "Bytes received on host0",
        "options" => %{"no_data_timeframe" => 20,
                       "notify_audit" => false,
                       "notify_no_data" => false,
                       "silenced" => %{}},
        "org_id" => 1499,
        "query" => "avg(last_1h):sum:system.net.bytes_rcvd{host:host0} > 100",
        "type" => "metric alert",
        "state" => %{
          "groups" => %{
            "host:host0" => %{
              "last_nodata_ts" => nil,
              "last_notified_ts" => 1_481_909_160,
              "last_resolved_ts" => 1_481_908_200,
              "last_triggered_ts" => 1_481_909_160,
              "name" => "host:host0",
              "status" => "Alert",
              "triggering_value" => %{
                "from_ts" => 1_481_909_037,
                "to_ts" => 1_481_909_097,
                "value" => 1_000}
            }
          }
        }
      }
    }

    use_cassette "details_with_group_states" do
      assert details(91_879, ~w(alert warn), client) == expected
    end
  end
end
