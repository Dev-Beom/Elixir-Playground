defmodule Day8 do
  @width 25
  @height 6

  def run() do
    input = File.read!("inputs/08.txt")
    input |> part1() |> IO.inspect()
    input |> part2()
  end

  defp part1(input) do
    min = decode(input) |> Enum.min_by(fn image -> Enum.count(image, &(&1 == "0")) end)
    Enum.count(min, &(&1 == "1")) * Enum.count(min, &(&1 == "2"))
  end

  defp part2(input) do
    decode(input)
    |> Enum.zip()
    |> Enum.map_join(fn image -> Enum.find(Tuple.to_list(image), &(&1 != "2")) end)
    |> String.replace("0", " ")
    |> String.replace("1", "#")
    |> String.codepoints()
    |> Enum.chunk_every(@width)
    |> Enum.map(fn e -> Enum.join(e) end) |> Enum.map(fn e -> IO.inspect(e) end)
  end

  defp decode(input) do
    String.trim(input)
    |> String.codepoints()
    |> Enum.chunk_every(@width * @height)
  end
end

Day8.run()
