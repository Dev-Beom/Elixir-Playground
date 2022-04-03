defmodule Day9 do
  @opcode_add 1
  @opcode_mul 2
  @opcode_input 3
  @opcode_output 4
  @opcode_jump_if_true 5
  @opcode_jump_if_false 6
  @opcode_less_then 7
  @opcode_equals 8
  @opcode_update_relative_base 9
  @opcode_exit 99

  @offset_next_modify 4
  @offset_next_io 2

  @position_mode 0
  @immediate_mode 1
  @relative_node 2

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

  def operation(%{halted: true} = context), do: context

  def operation(context) do
    context
    |> process()
    |> operation()
  end

  defp process(%{memory: memory, address: address} = context) do
    case Map.get(memory, address) |> opcode_and_modes() do
      {1, modes} -> add(context, modes)
      {2, modes} -> mul(context, modes)
      {3, modes} -> read_input(context, modes)
      {4, modes} -> write_output(context, modes)
      {5, modes} -> jump_if_true(context, modes)
      {6, modes} -> jump_if_false(context, modes)
      {7, modes} -> less_then(context, modes)
      {8, modes} -> equals(context, modes)
      {9, modes} -> update_relative_base(context, modes)
      {99, _} -> %{context | halted: true}
    end
  end

  defp get_relative_address(context, address), do: context.memory[address] + context.relative_base

  defp mode(modes, idx), do: Enum.at(modes, idx, 0)
  defp get(context, {address, @position_mode}), do: context.memory[context.memory[address]] || 0
  defp get(context, {address, @immediate_mode}), do: context.memory[address] || 0

  defp get(context, {address, @relative_node}),
    do: context.memory[get_relative_address(context, address)] || 0

  defp put(context, {result_address, 0}, value),
    do: Map.put(context.memory, context.memory[result_address], value)

  defp put(context, {result_address, 1}, value),
    do: Map.put(context.memory, result_address, value)

  defp put(context, {result_address, 2}, value) do
    result_address = get_relative_address(context, result_address)
    Map.put(context.memory, result_address, value)
  end

  defp params(context, modes) do
    {
      get(context, {context.address + 1, mode(modes, 0)}),
      get(context, {context.address + 2, mode(modes, 1)}),
      {context.address + 3, mode(modes, 2)},
      context.address + 4
    }
  end

  defp add(context, modes) do
    {param1, param2, address_mode, _} = params(context, modes)
    %{context | address: context.address + 4, memory: put(context, address_mode, param1 + param2)}
  end

  defp mul(context, modes) do
    {param1, param2, address_mode, _} = params(context, modes)
    %{context | address: context.address + 4, memory: put(context, address_mode, param1 * param2)}
  end

  defp jump_if_true(context, modes) do
    {param1, _, _, _} = params(context, modes)

    if param1 != 0 do
      %{context | address: get(context, {context.address + 2, mode(modes, 1)})}
    else
      %{context | address: context.address + 3}
    end
  end

  defp jump_if_false(context, modes) do
    {param1, _, _, _} = params(context, modes)

    if param1 == 0 do
      %{context | address: get(context, {context.address + 2, mode(modes, 1)})}
    else
      %{context | address: context.address + 3}
    end
  end

  defp less_then(context, modes) do
    {param1, param2, address_mode, next_address} = params(context, modes)

    if param1 < param2 do
      %{context | address: next_address, memory: put(context, address_mode, 1)}
    else
      %{context | address: next_address, memory: put(context, address_mode, 0)}
    end
  end

  def equals(context, modes) do
    {param1, param2, address_mode, next_address} = params(context, modes)

    if param1 == param2 do
      %{context | address: next_address, memory: put(context, address_mode, 1)}
    else
      %{context | address: next_address, memory: put(context, address_mode, 0)}
    end
  end

  defp read_input(context, modes) do
    addr_mode_result = {context.address + 1, mode(modes, 0)}
    [head | tail] = context.input

    %{
      context
      | address: context.address + 2,
        memory: put(context, addr_mode_result, head),
        input: tail
    }
  end

  defp write_output(context, modes) do
    value = get(context, {context.address + 1, mode(modes, 0)})
    %{context | address: context.address + 2, output: context.output ++ [value]}
  end

  defp update_relative_base(context, modes) do
    value = get(context, {context.address + 1, mode(modes, 0)})
    %{context | address: context.address + 2, relative_base: context.relative_base + value}
  end

  defp opcode_and_modes(num) do
    case Integer.digits(num) |> Enum.reverse() do
      [o2, o1 | modes] -> {o1 * 10 + o2, modes}
      [opcode] -> {opcode, []}
    end
  end

  defp generate_context(memory, input \\ []) do
    %{memory: memory, address: 0, input: input, output: [], halted: false, relative_base: 0}
  end

  defp offer_input(context, element), do: %{context | input: [element | context.input]}
  defp poll_first_output(%{output: [h | t]} = context), do: {h, %{context | output: t}}
  defp poll_first_output(%{output: []} = context), do: {nil, context}

  defp part_1(memory) do
    memory
    |> generate_context()
    |> offer_input(1)
    |> operation()
    |> poll_first_output()
    |> elem(0)
  end

  defp part_2(memory) do
    memory
    |> generate_context()
    |> offer_input(2)
    |> operation()
    |> Map.get(:output)
  end

  def run(input) do
    memory = input |> strs_to_ints() |> list_to_map()
    part_1(memory) |> IO.inspect()
    part_2(memory) |> IO.inspect()
  end
end

File.read!("inputs/09.txt") |> Day9.run()
