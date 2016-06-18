defmodule Rtb.Mixfile do
  use Mix.Project

  def project do
    [
      app: :rtb,
      version: "0.0.1",
      elixir: "~> 1.2",
      elixirc_paths: elixirc_paths(Mix.env),
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [
      applications: [
        :logger
      ],
      mod: {Rtb, []}
    ]
  end

  defp elixirc_paths(env) when env in ~w(dev test)a,
    do: ["lib", "test/support"]
  defp elixirc_paths(_),
    do: ["lib"]

  defp deps do
    [
      {:benchfella, "~> 0.3.0", only: :dev},
      {:earmark, "~> 0.2", only: :dev},
      {:ex_doc, "~> 0.12", only: :dev}
    ]
  end
end
