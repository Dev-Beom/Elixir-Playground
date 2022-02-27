defmodule BirdCount do
  def today(list), do: list |> List.first()

  def increment_day_count(list) do
    cond do
      length(list) == 0 -> [1]
      true -> [hd(list) + 1 | tl(list)]
    end
  end

  def has_day_without_birds?(list), do: 0 in list

  def total(list), do: list |> Enum.sum()

  def busy_days(list), do: list |> Enum.count(fn x -> x >= 5 end)
end
