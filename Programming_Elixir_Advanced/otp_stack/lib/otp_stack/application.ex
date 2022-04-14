defmodule OtpStack.Application do
  use Application

  def start(_type, _initial_numbers) do
    children = [
      {Stack.Server, Application.get_env(:otp_stack, :initial_number)}
    ]

    opts = [strategy: :one_for_one, name: OtpStack.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
