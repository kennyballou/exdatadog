defmodule Exdatadog.Metrics.Test do
  @moduledoc """
  Provides testing for Exdatadog.Metrics
  """
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  @cassette_dir "test/fixture/vcr_cassettes/metrics"

  alias Exdatadog.Client
  import Exdatadog.Metrics

  @lint {Credo.Check.Design.AliasUsage, false}
  setup_all do
    ExVCR.Config.cassette_library_dir(@cassette_dir)
  end

  test "can get list of active metrics" do
    client = Client.new()
    expected = {200, %{"metrics" => ["system.load.1",
                                     "system.load.15",
                                     "system.load.5",
                                     "system.load.norm.1",
                                     "system.load.norm.15",
                                     "system.load.norm.5",
                                     "system.mem.buffered",
                                     "system.mem.cached",
                                     "system.mem.committed",
                                     "system.mem.free"],
                       "from" => 1_467_815_773}
    }
    use_cassette "metrics" do
      assert metrics(1_467_815_773, client) == expected
    end
  end

  test "can post metrics" do
    client = Client.new(%{api_key: "1234"})
    expected = {202, %{"status" => "ok"}}
    post_body = %{"series" => [%{"metric" => "test_metric",
                                 "points" => [[1_430_311_800_000, 20]],
                                 "type" => "gauge",
                                 "host" => "test.example.com",
                                 "tags" => ["environment:test"]}]
    }
    use_cassette "post_series" do
      assert post_series(post_body, client) == expected
    end
  end

  test "can query metrics" do
    client = Client.new()
    expected = {200,
      %{"status" => "ok",
        "res_type" => "time_series",
        "series" => [%{"metric" =>"system.cpu.idle",
        "attributes" => %{},
        "display_name" => "system.cpu.idle",
        "unit" => nil,
        "pointlist" => [[1_430_311_800_000,
                         98.19375610351562],
                        [1_430_312_400_000,
                         99.85856628417969]],
        "end" => 1_430_312_999_000,
        "interval" => 600,
        "start" => 1_430_311_800_000,
        "length" => 2,
        "aggr" => nil,
        "scope" => "host:vagrant-ubuntu-trusty-64",
        "expression" => "system.cpu.idle{host:vagrant-ubuntu-trusty-64}"}],
        "from_date" => 1_430_226_140_000,
        "group_by" => ["host"],
        "to_date" => 1_430_312_540_000,
        "query" => "system.cpu.idle{*}by{host}",
        "message" => ""}
    }
    use_cassette "query" do
      assert query(1_430_311_800_000,
                   1_430_312_999_000,
                   "system.cpu.idle{*}by{host}",
                   client) == expected
    end
  end

end
