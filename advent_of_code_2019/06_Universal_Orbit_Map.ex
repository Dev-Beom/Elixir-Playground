# 얼랭 큐 참고
# https://www.erlang.org/doc/man/queue.html

defmodule Day6 do
  def file_read(path), do: path |> File.read!()

  # 모든 천체의 궤도의 수
  def part1(input) do
    parse_map(input)
    |> Enum.reduce(%{}, &add_key/2)
    |> compute_checksum("COM", 0)
  end

  # 천체 이동 BFS
  def part2(input) do
    parse_map(input)
    |> Enum.reduce(%{}, &add_graph_key/2)
    |> bfs("YOU", "SAN")
  end

  defp parse_map(input) do
    String.trim(input)
    |> String.split("\n")
    |> Enum.map(&String.split(&1, ")"))
  end

  # defp add_key([a, b], map), do: Map.update(map, a, [b], &[b | &1])
  defp add_key([a, b], map), do: Map.update(map, a, [b], fn val -> [b | val] end)

  defp compute_checksum(map, key, res) do
    Map.get(map, key, [])
    |> Enum.map(&compute_checksum(map, &1, res + 1))
    |> Enum.sum()
    |> Kernel.+(res)
  end

  defp add_graph_key([a, b], map), do: add_key([b, a], add_key([a, b], map))

  defp bfs(map, start_node, end_node) do
    bfs(map, :queue.from_list([{start_node, -1}]), MapSet.new([start_node]), end_node)
  end

  defp bfs(map, queue, seen, end_node) do
    {{:value, {curr_node, depth}}, queue} = :queue.out(queue)
    dir = Map.get(map, curr_node, []) |> Enum.filter(&(!MapSet.member?(seen, &1)))
    # queue = Enum.reduce(dir, queue, &:queue.in({&1, depth + 1}, &2))
    queue =
      Enum.reduce(dir, queue, fn curr_node, queue ->
        :queue.in({curr_node, depth + 1}, queue)
      end)

    seen = Enum.reduce(dir, seen, &MapSet.put(&2, &1))

    # if Enum.any?(dir, &(&1 == end_node)) do
    if Enum.any?(dir, fn e -> e == end_node end) do
      depth
    else
      bfs(map, queue, seen, end_node)
    end
  end
end

Day6.file_read("inputs/06.txt") |> Day6.part1() |> IO.inspect()
Day6.file_read("inputs/06.txt") |> Day6.part2() |> IO.inspect()
