defmodule Kotkowo.MixProject do
  use Mix.Project

  def project do
    [
      app: :kotkowo,
      version: "0.1.0",
      elixir: "~> 1.15",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        check: :test,
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Kotkowo.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.7"},
      {:phoenix_html, "~> 3.3.2"},
      {:phoenix_live_reload, "~> 1.5", only: :dev},
      {:phoenix_live_view, "~> 1.0"},
      {:phoenix_live_dashboard, "~> 0.8"},
      {:rustler, "~> 0.32.1"},
      {:req, "~> 0.5.10"},
      {:earmark, "~> 1.4"},
      {:tz, "~> 0.28.1"},
      {:html_sanitize_ex, "~> 1.4"},
      {:heroicons, "~> 0.5"},
      {:esbuild, "~> 0.7.1", runtime: Mix.env() == :dev},
      {:tailwind, "~> 0.2.1", runtime: Mix.env() == :dev},
      {:tails, "~> 0.1.7"},
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 1.0"},
      {:gettext, "~> 0.20"},
      {:bandit, "~> 1.5"},
      {:sentry, "== 10.0.0"},
      {:jason, "~> 1.1"},
      {:hackney, "~> 1.8"},
      {:prom_ex, "~> 1.9"},
      {:styler, "~> 0.8", only: [:dev, :test], runtime: false},
      {:gradient, github: "esl/gradient", only: [:dev, :test], runtime: false},
      {:gradient_macros,
       [
         git: "https://github.com/esl/gradient_macros.git",
         ref: "3bce214",
         runtime: false,
         override: true
       ]},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:sobelow, "~> 0.13", only: [:dev, :test], runtime: false}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get"],
      test: ["test"],
      "assets.deploy": ["tailwind default --minify", "esbuild default --minify", "phx.digest"],
      check: [
        "compile --warnings-as-errors --all-warnings",
        "format --check-formatted",
        "credo",
        "test",
        "gradient"
      ]
    ]
  end
end
