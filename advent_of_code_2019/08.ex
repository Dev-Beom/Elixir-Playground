defmodule Day8 do
  def digits(input) do
    String.to_charlist(input)
    |> Enum.map(&(&1 - ?0))
  end

  def run() do
    input = File.read!("inputs/08.txt")
    input |> part1() |> IO.inspect()
    input |> part2() |> IO.inspect()
  end

  def part_1(input) do
    layer_size = 25 * 6

    layer =
      input
      |> digits()
      |> Enum.chunk_every(layer_size)
      |> Enum.min_by(fn layer -> Enum.count(layer, &(&1 == 0)) end)

    Enum.count(layer, &(&1 == 1)) * Enum.count(layer, &(&1 == 2))
  end

  def part_2(input) do
    width = 25
    height = 6

    input
    |> digits()
    |> Enum.chunk_every(width * height)
    |> Enum.reduce(fn layer, image ->
      Enum.zip(image, layer)
      |> Enum.map(fn
        {2, layer_pixel} -> layer_pixel
        {image_pixel, _} -> image_pixel
      end)
    end)
    |> Enum.map(fn
      0 -> "0"
      1 -> "1"
    end)
    |> Enum.chunk_every(width)
    |> Enum.join("\n")
  end

  def part1(input) do
    min = decode_layers(input) |> Enum.min_by(fn image -> Enum.count(image, &(&1 == "0")) end)
    Enum.count(min, &(&1 == "1")) * Enum.count(min, &(&1 == "2"))
  end

  def part2(input) do
    decode_layers(input)
    |> Enum.zip()
    |> Enum.map_join(fn image -> Enum.find(Tuple.to_list(image), &(&1 != "2")) end)
  end

  defp decode_layers(input) do
    String.trim(input) |> String.codepoints() |> Enum.chunk_every(25 * 6)
  end
end

Day8.run()
