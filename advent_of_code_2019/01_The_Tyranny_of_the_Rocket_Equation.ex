defmodule Day1 do
  defp filter(e), do: div(e, 3) - 2

  defp strs_to_ints(strs) do
    strs
    |> Kino.Input.read()
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  defp sum_of_values(values) do
    values
    |> Enum.map(&filter/1)
    |> Enum.sum()
  end

  def total_of_fuel_requir(res, sum) do
    sum = filter(sum)

    cond do
      sum <= 0 -> res
      true -> total_of_fuel_requir(res + sum, sum)
    endds
  end

  def part_1(input) do
    input
    |> strs_to_ints
    |> sum_of_values
  end

  def part_2(input) do
    input
    |> strs_to_ints
    |> Enum.map(&total_of_fuel_requir(0, &1))
    |> Enum.sum()
  end

  def run(input) do
    input |> part_1 |> IO.inspect()
    input |> part_2 |> IO.inspect()
  end
end
