defmodule OtpStack.MixProject do
  use Mix.Project

  def project do
    [
      app: :otp_stack,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {OtpStack.Application, []},
      registered: [
        Stack.Server
      ],
      env: [initial_number: [1,2,3]]
    ]
  end

  defp deps do
    [
      {:distillery, "~> 2.1", runtime: false},
    ]
  end
end
