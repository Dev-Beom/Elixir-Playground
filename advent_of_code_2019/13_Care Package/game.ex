defmodule Game do
  defstruct titles: %{}, score: 0, output: []

  def play(str, quarters \\ 1) do
    {:ok, _pid} = Agent.start_link(fn -> %Game{} end, name: __MODULE__)
  end
end
