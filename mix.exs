defmodule TogglVatChecker.Mixfile do
  use Mix.Project

  @version "0.1.0"
  def project do
    [
      app: :toggl_vat_checker,
      version: @version,
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps(),
      escript: [main_module: TogglVatChecker.CLI],

      elixirc_options: [warnings_as_errors: Mix.env != :dev],
      dialyzer: [ flags: ["-Wunmatched_returns", :error_handling, :race_conditions],
                  remove_defaults: [:unknown]],

      # Docs
      name: "Toggle VAT Checker - coding test",
      docs: [output: "./docs",
             canonical: "https://nirev.github.io/toggl_vat_checker",
             source_url: "https://github.com/nirev/toggl_vat_checker"]
    ]
  end

  def application do
    [
      extra_applications: [:logger, :httpoison]
    ]
  end

  defp deps do
    [
      {:credo, "~> 0.8", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 0.5", only: [:dev], runtime: false},
      {:earmark, "~> 1.1", only: :dev},
      {:ex_doc, "~> 0.16", only: :dev},
      {:httpoison, "~> 0.13"},
    ]
  end
end
