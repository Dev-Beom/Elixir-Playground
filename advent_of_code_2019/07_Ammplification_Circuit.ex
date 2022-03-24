defmodule Utils.Permutation do
  def of([]), do: [[]]
  def of(list), do: for(head <- list, tail <- of(list -- [head]), do: [head | tail])
end

defmodule Amplifier do
  defstruct phase: 0, next_pointer: 0, memory: %{}, is_finish: false, is_used: false
end

defmodule Day7 do
  @opcode_add 1
  @opcode_mul 2
  @opcode_input 3
  @opcode_output 4
  @opcode_jump_if_true 5
  @opcode_jump_if_false 6
  @opcode_less_then 7
  @opcode_equals 8
  @opcode_exit 99

  @offset_next_modify 4
  @offset_next_io 2

  @position_mode 0
  @immediate_mode 1

  defp strs_to_ints(strs) do
    strs
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end

  defp list_to_map(list) do
    0..length(list)
    |> Stream.zip(list)
    |> Enum.into(%{})
  end

  defp operation(memory, inputs), do: operation(memory, 0, inputs)

  @spec operation(map(), integer(), list()) :: map() | integer()
  defp operation(memory, address, inputs) do
    case process(memory, address, inputs) do
      {:halt, memory} -> {:halt, memory}
      {:output, next_address, memory, value} -> {:output, next_address, memory, value}
      {:input, next_address, memory} -> operation(memory, next_address, tl(inputs))
      {next_address, memory} -> operation(memory, next_address, inputs)
    end
  end

  @doc """
  address에서 옵코드 처리 후 memory 맵 반환
  """
  @spec process(map(), integer(), list()) :: {integer(), map()}
  defp process(memory, address, inputs) do
    case Map.get(memory, address) |> opcode_and_modes() do
      {@opcode_add, modes} ->
        {address + @offset_next_modify,
         add(
           memory,
           {address + 1, mode(modes, 0)},
           {address + 2, mode(modes, 1)},
           {address + 3, mode(modes, 2)}
         )}

      {@opcode_mul, modes} ->
        {address + @offset_next_modify,
         mul(
           memory,
           {address + 1, mode(modes, 0)},
           {address + 2, mode(modes, 1)},
           {address + 3, mode(modes, 2)}
         )}

      {@opcode_input, modes} ->
        {:input, address + @offset_next_io,
         read_input(memory, {address + 1, mode(modes, 0)}, hd(inputs))}

      {@opcode_output, modes} ->
        # {address + @offset_next_io, write_output(memory, {address + 1, mode(modes, 0)})}
        {memory, value} = write_output(memory, {address + 1, mode(modes, 0)})
        {:output, address + @offset_next_io, memory, value}

      {@opcode_jump_if_true, modes} ->
        jump_if_true(memory, address, modes)

      {@opcode_jump_if_false, modes} ->
        jump_if_false(memory, address, modes)

      {@opcode_less_then, modes} ->
        less_then(memory, address, modes)

      {@opcode_equals, modes} ->
        equals(memory, address, modes)

      {@opcode_exit, _} ->
        {:halt, memory}
    end
  end

  defp mode(modes, idx), do: Enum.at(modes, idx, 0)
  defp get(memory, {address, @position_mode}), do: memory[memory[address]]
  defp get(memory, {address, @immediate_mode}), do: memory[address]
  defp put(memory, {result_address, 0}, value), do: Map.put(memory, memory[result_address], value)
  defp put(memory, {result_address, 1}, value), do: Map.put(memory, result_address, value)

  defp params(memory, address, modes) do
    {
      get(memory, {address + 1, mode(modes, 0)}),
      get(memory, {address + 2, mode(modes, 1)}),
      {address + 3, mode(modes, 2)},
      address + 4
    }
  end

  defp add(memory, mode_1, mode_2, addr_mode_result) do
    put(memory, addr_mode_result, get(memory, mode_1) + get(memory, mode_2))
  end

  defp mul(memory, mode_1, mode_2, addr_mode_result) do
    put(memory, addr_mode_result, get(memory, mode_1) * get(memory, mode_2))
  end

  def read_input(memory, addr_mode_result, input) do
    put(memory, addr_mode_result, input)
  end

  def write_output(memory, addr_mode_value) do
    value = get(memory, addr_mode_value)
    {memory, value}
  end

  # 첫번째 매개변수가 0이 아닌 경우 두번째 매개변수의 값에 명령 포인터 설정
  defp jump_if_true(memory, address, modes) do
    {param1, param2, _, _} = params(memory, address, modes)

    if param1 != 0 do
      pointer = param2
      {pointer, memory}
    else
      {address + 3, memory}
    end
  end

  # 첫번째 매개변수가 0이면 명령 포인터를 두번째 매개변수의 값으로 설정
  defp jump_if_false(memory, address, modes) do
    {param1, param2, _, _} = params(memory, address, modes)

    if param1 == 0 do
      pointer = param2
      {pointer, memory}
    else
      {address + 3, memory}
    end
  end

  # 첫번째 파라미터가 두 번째 파라미터보다 작으면 세 번째 파라미터에 주어진 위치에 1이 저장 or 0 저장
  defp less_then(memory, address, modes) do
    {param1, param2, address_mode, pointer} = params(memory, address, modes)

    if param1 < param2 do
      {pointer, put(memory, address_mode, 1)}
    else
      {pointer, put(memory, address_mode, 0)}
    end
  end

  # 첫 번째 파라미터가 두 번째 파라미터보다 작으면 세번째 파라미터에 주어진 위치에 1이 저장 or 0 저장
  def equals(memory, address, modes) do
    {param1, param2, address_mode, pointer} = params(memory, address, modes)

    if param1 == param2 do
      {pointer, put(memory, address_mode, 1)}
    else
      {pointer, put(memory, address_mode, 0)}
    end
  end

  @spec opcode_and_modes(String.t()) :: {integer(), list()}
  defp opcode_and_modes(num) do
    case Integer.digits(num) |> Enum.reverse() do
      [o2, o1 | modes] -> {o1 * 10 + o2, modes}
      [opcode] -> {opcode, []}
    end
  end

  defp part_1(memory) do
    0..4
    |> Enum.to_list()
    |> Utils.Permutation.of()
    |> Enum.map(&runner(memory, &1))
    |> Enum.max()
    |> IO.inspect()
  end

  defp part_2(memory) do
    5..9
    |> Enum.to_list()
    |> Utils.Permutation.of()
    |> Enum.map(fn phases ->
      # 컴퓨터들 상태 생성해서 배열로 만들어서 놓고
      # phases를 돌면서 계속 돌면서 reduce while 를 통해 해결 ?

      amps =
        phases
        |> Enum.map(
          &%Amplifier{
            phase: &1,
            next_pointer: 0,
            memory: memory,
            is_finish: false,
            is_used: false
          }
        )

      feedback_runner(amps, 0)
      # phases
      # |> Stream.cycle()

      # |> Enum.reduce_while({computer_map, [0]}, fn
      #   phase, {cpt_map, :halt} ->
      #     {:halt, cpt_map[List.last(phases)].outputs |> List.first()}

      #   phase, {cpt_map, outputs} ->
      #     state = cpt_map[phase]
      #     {state, outputs} = Computer.process(state, outputs)
      #     {:cont, {cpt_map |> Map.put(phase, state), outputs}}
      # end)
    end)
  end

  defp runner(memory, phases) do
    Enum.reduce(phases, 0, fn phase, sum ->
      {:output, _next_address, _memory, value} = operation(memory, [phase, sum])
      value
    end)
  end

  defp feedback_runner(amps, finish) do
    [head | tail] = amps

    # {:output, next_address, memory, value} =
    #   operation(head.memory, head.next_pointer, [head.phase])

    # new_head = %{head | is_used: true}
    # amps = [tail | new_head]
    # feedback_runner()
  end

  # defp feedback_runner(amps, finish, input) do
  #   first = hd(amps)
  #   {:output, next_address, memory, value} = operation(memory, next_address, [input])
  # end

  def run(input) do
    # memory = input |> Kino.Input.read() |> strs_to_ints() |> list_to_map()
    memory = input |> strs_to_ints() |> list_to_map()
    part_1(memory)
    part_2(memory)
  end

  def test() do
  end
end

# Day7.test()

File.read!("inputs/07.txt") |> Day7.run()

defmodule Counter do
  use Agent

  @spec start_link(integer(), atom()) :: any()
  def start_link(initial_value, tag) do
    Agent.start_link(fn -> initial_value end, name: tag)
  end

  def value(tag) do
    Agent.get(tag, & &1)
  end

  def increment(tag) do
    Agent.update(tag, &(&1 + 1))
  end
end

Counter.start_link(0, :brave)
Counter.start_link(0, :benn)
Counter.value(:brave)
Counter.increment(:brave)
Counter.increment(:brave)
Counter.increment(:brave)
Counter.value(:brave) |> IO.inspect()
Counter.value(:benn) |> IO.inspect()
