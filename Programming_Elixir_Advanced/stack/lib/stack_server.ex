defmodule Stack.Server do
  use GenServer

  @me __MODULE__

  def start_link(init_components) do
    GenServer.start_link(@me, init_components, name: @me)
  end

  def pop() do
    GenServer.call(@me, :pop)
  end

  def push(top) do
    GenServer.cast(@me, {:push, top})
  end

  def init(init_components) when is_list(init_components) do
    {:ok, init_components}
  end

  def init(init_components) do
    {:error, "리스트로 초기화해줘 #{init_components} 이건 리스트가 아니잖아...^^"}
  end

  def handle_call(:pop, _from, []), do: System.halt(0)
  def handle_call(:pop, _from, [head | tail] = current_list), do: {:reply, head, tail}

  def handle_cast({:push, top}, _) when 10 > top, do: System.halt(top)
  def handle_cast({:push, top}, current_list), do: {:noreply, [top | current_list]}
end
