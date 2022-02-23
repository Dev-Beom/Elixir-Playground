defmodule Day2 do
  @opcode_plus 1
  @opcode_mult 2
  @opcode_exit 99
  @max_number 99
  @offset_noun 1
  @offset_verb 2
  @offset_to 3
  @offset_next 4

  defp strs_to_ints(strs) do
    strs
    |> Kino.Input.read()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end

  defp list_to_map(list) do
    0..length(list)
    |> Stream.zip(list)
    |> Enum.into(%{})
  end

  defp get_oper_info(memory, idx) do
    to = memory |> Map.get(idx + @offset_to)

    %{
      to: to,
      noun: Map.get(memory, idx + @offset_noun),
      verb: Map.get(memory, idx + @offset_verb)
    }
  end

  defp mark_plus(memory, idx) do
    info = get_oper_info(memory, idx)
    Map.put(memory, info.to, Map.get(memory, info.noun) + Map.get(memory, info.verb))
  end

  defp mark_mult(memory, idx) do
    info = get_oper_info(memory, idx)
    Map.put(memory, info.to, Map.get(memory, info.noun) * Map.get(memory, info.verb))
  end

  defp exec(memory, idx \\ 0) do
    case Map.get(memory, idx) do
      @opcode_plus -> mark_plus(memory, idx) |> exec(idx + @offset_next)
      @opcode_mult -> mark_mult(memory, idx) |> exec(idx + @offset_next)
      @opcode_exit -> memory
    end
  end

  defp get_noun_verb(memory, target) do
    for noun <- 0..@max_number,
        verb <- 0..@max_number,
        new_mem =
          memory
          |> Map.put(1, noun)
          |> Map.put(2, verb)
          |> exec,
        Map.get(new_mem, 0) == target do
      noun * 100 + verb
    end
  end

  def part_1(input) do
    input
    |> strs_to_ints
    |> list_to_map
    |> Map.put(1, 12)
    |> Map.put(2, 2)
    |> exec
    |> Map.get(0)
  end

  def part_2(input) do
    input
    |> strs_to_ints
    |> list_to_map
    |> get_noun_verb(1969_0720)
  end

  def run(input) do
    input |> part_1 |> IO.inspect()
    input |> part_2 |> IO.inspect()
  end
end
