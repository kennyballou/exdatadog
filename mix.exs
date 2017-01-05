defmodule Exdatadog.Mixfile do
  use Mix.Project

  def project do
    [app: :exdatadog,
     description: "Elixir Datadog API Client",
     package: package(),
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     test_coverage: [tool: ExCoveralls],
     docs: docs()]
  end

  def application do
    [applications: [:logger, :httpoison]]
  end

  defp deps do
    [{:credo, "~> 0.5.0", only: :dev},
     {:excoveralls, "~> 0.5", only: :test},
     {:earmark, "~> 0.1", only: :dev},
     {:ex_doc, "~> 0.11", only: :dev},
     {:exvcr, "~> 0.8.4", only: :test},
     {:httpoison, "~> 0.10.0"},
     {:meck, "~> 0.8", only: :test},
     {:poison, "~> 2.2.0"}]
  end

  defp docs do
    [extras: ["README.md"]]
  end

  defp package do
    [maintainers: ["Kenny Ballou"],
     licenses: ["Apache 2.0"],
     links: %{"Git" => "https://git.devnulllabs.io/exdatadog.git",
              "GitHub" => "https://github.com/kennyballou/exdatadog.git",
              "Hex" => "https://hex.pm/packages/exdatadog",
              "Hex Docs" => "https://hexdocs.pm/exdatadog"},
     files: ~w(mix.exs README.md LICENSE lib)]
  end
end
