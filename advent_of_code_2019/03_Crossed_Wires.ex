defmodule Day3 do
  defp generate_wires(line) do
    {map, _, _} = line |> String.split(",") |> Enum.reduce({%{}, {0, 0}, 0}, &move/2)
    map
  end

  defp move(<<direction, count::binary>>, {visited, pos, distance}) do
    count = String.to_integer(count)
    next_position = &get_next_position(&1, direction, pos)

    new_visited =
      Enum.reduce(1..count, visited, &Map.put_new(&2, next_position.(&1), distance + &1))

    {new_visited, next_position.(count), distance + count}
  end

  defp get_next_position(count, direction, {x, y}) do
    case direction do
      ?U -> {x, y - count}
      ?D -> {x, y + count}
      ?L -> {x - count, y}
      ?R -> {x + count, y}
    end
  end

  defp map_intersect(a, b) do
    ak = Map.keys(a) |> MapSet.new()
    bk = Map.keys(b) |> MapSet.new()
    MapSet.intersection(ak, bk) |> Enum.map(&(Map.get(a, &1) + Map.get(b, &1)))
  end

  defp manhattan_distance({x, y}), do: abs(x) + abs(y)

  defp part_1(lines) do
    lines
    |> Enum.map(&generate_wires/1)
    |> Enum.map(&Map.keys/1)
    |> Enum.map(&MapSet.new/1)
    |> Enum.reduce(&MapSet.intersection/2)
    |> Enum.map(&manhattan_distance/1)
    |> Enum.min()
  end

  defp part_2(lines) do
    lines
    |> Enum.map(&generate_wires/1)
    |> Enum.reduce(&map_intersect/2)
    |> Enum.min()
  end

  def run(lines) do
    lines |> part_1() |> IO.inspect()
    lines |> part_2() |> IO.inspect()
  end
end
