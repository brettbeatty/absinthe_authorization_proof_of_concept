defmodule Scv.MixProject do
  use Mix.Project

  def project do
    [
      app: :scv,
      version: "0.0.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: [
        {:absinthe_plug, "~> 1.4"},
        {:jason, "~> 1.1"},
        {:plug_cowboy, "~> 2.1"}
      ]
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Scv.Application, []}
    ]
  end
end
