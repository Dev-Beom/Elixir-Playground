defmodule Day11 do
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
      {@opcode_add, modes} -> add(context, modes)
      {@opcode_mul, modes} -> mul(context, modes)
      {@opcode_input, modes} -> read_input(context, modes)
      {@opcode_output, modes} -> write_output(context, modes)
      {@opcode_jump_if_true, modes} -> jump_if_true(context, modes)
      {@opcode_jump_if_false, modes} -> jump_if_false(context, modes)
      {@opcode_less_then, modes} -> less_then(context, modes)
      {@opcode_equals, modes} -> equals(context, modes)
      {@opcode_update_relative_base, modes} -> update_relative_base(context, modes)
      {@opcode_exit, _} -> %{context | halted: true}
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
    [head | tail] = [get_color(context) | context.input]

    %{
      context
      | address: context.address + 2,
        memory: put(context, addr_mode_result, head),
        input: tail
    }
  end

  defp write_output(context, modes) do
    value = get(context, {context.address + 1, mode(modes, 0)})
    new_output = context.output ++ [value]

    if length(new_output) >= 2 do
      [draw_color, direction] = new_output
      context = draw_color(context, draw_color) |> turn(direction) |> move()

      %{context | address: context.address + 2, output: []}
    else
      %{context | address: context.address + 2, output: context.output ++ [value]}
    end
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

  defp generate_context(memory, board_context, input \\ []) do
    %{
      memory: memory,
      address: 0,
      input: input,
      output: [],
      halted: false,
      relative_base: 0,
      board: board_context
    }
  end

  defp generate_board_context(start_color) do
    %{
      map_info: [
        %{x: 0, y: 0, count: 0, color: start_color}
      ],
      current_position: %{x: 0, y: 0, direction: 0}
    }
  end

  defp get_color(%{board: board_context} = _context) do
    %{color: color} =
      board_context.map_info
      |> Stream.filter(fn %{x: x, y: y} ->
        board_context.current_position.x == x and board_context.current_position.y == y
      end)
      |> Enum.at(0)

    color
  end

  defp draw_color(%{board: board_context} = context, color) do
    %{x: x, y: y} = board_context.current_position

    new_board_context_map_info =
      board_context.map_info
      |> Enum.map(fn e ->
        if e.x == x and e.y == y do
          %{e | count: e.count + 1, color: color}
        else
          e
        end
      end)

    new_board_context = %{board_context | map_info: new_board_context_map_info}
    %{context | board: new_board_context}
  end

  @turn_left 0
  @turn_right 1
  defp turn(%{board: board} = context, oper) when is_integer(oper) do
    direction = context.board.current_position.direction

    new_direction =
      case oper do
        @turn_right -> rem(direction + 1, 4)
        @turn_left -> rem(direction - 1 + 4, 4)
      end

    new_board =
      Map.update(board, :current_position, nil, fn %{x: x, y: y, direction: _direction} ->
        %{x: x, y: y, direction: new_direction}
      end)

    %{context | board: new_board}
  end

  defp move(%{board: board} = context) do
    x_arr = [0, 1, 0, -1]
    y_arr = [-1, 0, 1, 0]
    curr_position = board.current_position

    [new_x, new_y] = [
      curr_position.x + Enum.at(x_arr, curr_position.direction),
      curr_position.y + Enum.at(y_arr, curr_position.direction)
    ]

    new_current_position = %{curr_position | x: new_x, y: new_y}

    new_map_info =
      case Enum.count(board.map_info, fn e -> e.x == new_x and e.y == new_y end) do
        0 -> [%{color: 0, count: 0, x: new_x, y: new_y} | board.map_info]
        _ -> board.map_info
      end

    new_board = %{current_position: new_current_position, map_info: new_map_info}

    %{context | board: new_board}
  end

  defp poll_first_output(%{output: [h | t]} = context), do: {h, %{context | output: t}}
  defp poll_first_output(%{output: []} = context), do: {nil, context}



  @black_color 0
  @white_color 1
  defp part_1(memory) do
    result = memory |> generate_context(generate_board_context(@black_color)) |> operation()
    map_info = result.board.map_info
    length(map_info)
  end

  defp part_2(memory) do
    result = memory |> generate_context(generate_board_context(@white_color)) |> operation()
    map_info = result.board.map_info
    {%{x: x_min}, %{x: x_max}} = Enum.min_max_by(map_info, &(&1.x))
    {%{y: y_min}, %{y: y_max}} = Enum.min_max_by(map_info, &(&1.y))

    for y <- y_min..y_max do
      for x <- x_min..x_max do
        find = Enum.filter(map_info, &(&1.x == x and &1.y == y))

        if length(find) == 0 do
          "⬜️"
        else
          case Enum.at(find, 0).color do
            0 -> "⬜️"
            1 -> "⬛️"
          end
        end
      end
      |> Enum.join()
    end
    |> Enum.join("\n")
  end

  def run(input) do
    memory = input |> strs_to_ints() |> list_to_map()
    part_1(memory) |> IO.inspect()
    part_2(memory) |> IO.puts()
  end
end

File.read!("inputs/11.txt") |> Day11.run()
