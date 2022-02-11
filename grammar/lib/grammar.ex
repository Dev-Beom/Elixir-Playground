defmodule Grammar do
  use Application

  def start(_type, _args) do
    IO.puts("Hello")

    # immutable data is known Data
    list1 = [3, 2, 1]
    list2 = [4 | list1]
    IO.inspect(list2)

    # Coding with Immutable Data
    name = "elixir"
    cap_name = String.capitalize(name)
    IO.inspect(name)
    IO.inspect(cap_name)

    Task.start(fn ->
      :timer.sleep(1000)
      IO.puts("done sleeping")
    end)
  end
end
