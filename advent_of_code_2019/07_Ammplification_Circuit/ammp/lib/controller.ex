defmodule Computer.Controller do
  use GenServer

  alias Computer.Service
  alias Computer.Utils

  def init(state), do: {:ok, state}

  def excute(memory, phases) do
    Enum.reduce(phases, 0, fn phase, signal ->
      Service.operation(memory, [phase, signal])
    end)
  end
end
