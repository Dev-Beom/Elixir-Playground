defmodule Computer.Service do
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

  @param_mode 0
  @param_mode 1

  def operation(memory, inputs), do: operation(memory, 0, inputs)

  def operation(memory, address, inputs) do
    case process(memory, address, inputs) do
      {:halt, result} -> result
      {next_address, memory} -> operation(memory, next_address, inputs)
    end
  end

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
        {address + @offset_next_io, read_input(memory, {address + 1, mode(modes, 0)}, hd(inputs))}

      {@opcode_output, modes} ->
        # {address + @offset_next_io, write_output(memory, {address + 1, mode(modes, 0)})}
        {:halt, write_output(memory, {address + 1, mode(modes, 0)})}

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
  defp get(memory, {address, @param_mode}), do: memory[memory[address]]
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

  defp add(memory, mode_1, mode_2, addr_mode_result),
    do: put(memory, addr_mode_result, get(memory, mode_1) + get(memory, mode_2))

  defp mul(memory, mode_1, mode_2, addr_mode_result),
    do: put(memory, addr_mode_result, get(memory, mode_1) * get(memory, mode_2))

  defp jump_if_true(memory, address, modes) do
    {param1, param2, _, _} = params(memory, address, modes)

    if param1 != 0 do
      pointer = param2
      {pointer, memory}
    else
      {address + 3, memory}
    end
  end

  defp jump_if_false(memory, address, modes) do
    {param1, param2, _, _} = params(memory, address, modes)

    if param1 == 0 do
      pointer = param2
      {pointer, memory}
    else
      {address + 3, memory}
    end
  end

  defp less_then(memory, address, modes) do
    {param1, param2, address_mode, pointer} = params(memory, address, modes)

    if param1 < param2 do
      {pointer, put(memory, address_mode, 1)}
    else
      {pointer, put(memory, address_mode, 0)}
    end
  end

  def equals(memory, address, modes) do
    {param1, param2, address_mode, pointer} = params(memory, address, modes)

    if param1 == param2 do
      {pointer, put(memory, address_mode, 1)}
    else
      {pointer, put(memory, address_mode, 0)}
    end
  end

  def read_input(memory, addr_mode_result, input) do
    put(memory, addr_mode_result, input)
  end

  def write_output(memory, addr_mode_value) do
    value = get(memory, addr_mode_value)
    value
    # IO.puts("::-> #{value}")
    # memory
  end

  defp opcode_and_modes(num) do
    case Integer.digits(num) |> Enum.reverse() do
      [o2, o1 | modes] -> {o1 * 10 + o2, modes}
      [opcode] -> {opcode, []}
    end
  end

  # defp part_1(memory) do
  #   IO.puts("PART_1")
  #   memory |> operation(1)
  # end

  # defp part_2(memory) do
  #   IO.puts("PART_2")
  #   memory |> operation(5)
  # end

  # def run(input) do
  #   memory = input |> strs_to_ints() |> list_to_map()
  #   part_1(memory)
  #   part_2(memory)
  # end
end
