defmodule Exdatadog.Search.Test do
  @moduledoc """
  Tests Exdatadog.Search
  """
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  @cassette_dir "test/fixture/vcr_cassettes/search"

  alias Exdatadog.Client
  import Exdatadog.Search

  doctest Exdatadog.Search

  @lint {Credo.Check.Design.AliasUsage, false}
  setup_all do
    ExVCR.Config.cassette_library_dir(@cassette_dir)
  end

  test "search with un-faceted query" do
    client = Client.new()
    expected = {
      200,
      %{"results" => %{"metrics" => ["test.metric"],
                       "hosts" => ["test.another.example.com",
                                   "test.example.com",
                                   "test.host",
                                   "test.metric.host",
                                   "test.tag.host"]}}
    }
    use_cassette "unfaceted" do
      assert search("test", client) == expected
    end
  end

  test "search with faceted query" do
    client = Client.new()
    expected = {
      200,
      %{"results" => %{"hosts" => ["test.another.example.com",
                                   "test.example.com",
                                   "test.host",
                                   "test.metric.host",
                                   "test.tag.host"]}}
    }
    use_cassette "faceted" do
      assert search("hosts:test", client) == expected
    end
  end

end
