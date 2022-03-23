defmodule Day4 do
  defp input_conv(input) do
    input
    |> Kino.Input.read()
    |> String.split("-")
    |> Enum.map(&String.to_integer(&1))
  end

  defp has_same_adjacent_digits([]), do: true

  defp has_same_adjacent_digits([head | tail]) do
    next = List.first(tail)

    case next do
      ^head -> next
      nil -> false
      _ -> has_same_adjacent_digits(tail)
    end
  end

  # DFS
  defp has_two_same_adjacent_digits([head | tail]),
    do: has_two_same_adjacent_digits(tail, head, 1, [])

  defp has_two_same_adjacent_digits([], tmp, count, acc) do
    valid = (acc ++ [{tmp, count}]) |> Enum.filter(fn {_, count} -> count == 2 end)
    # length(valid) > 0
    valid != []
  end

  defp has_two_same_adjacent_digits([head | tail], tmp, count, acc) do
    if head == tmp do
      has_two_same_adjacent_digits(tail, head, count + 1, acc)
    else
      has_two_same_adjacent_digits(tail, head, 1, acc ++ [{tmp, count}])
    end
  end

  defp is_asc([head | tail]) do
    next = List.first(tail)

    cond do
      next == nil -> true
      head > next -> false
      true -> is_asc(tail)
    end
  end

  defp is_within_range(password, from, to), do: from <= password && password <= to

  defp valid_password?(password, from, to) do
    Enum.all?([
      is_within_range(String.to_integer(password), from, to),
      has_same_adjacent_digits(String.to_charlist(password)),
      is_asc(String.to_charlist(password))
    ])
  end

  defp valid_password?(password, from, to, _) do
    Enum.all?([
      is_within_range(String.to_integer(password), from, to),
      has_two_same_adjacent_digits(String.to_charlist(password)),
      is_asc(String.to_charlist(password))
    ])
  end

  defp part_1([from, to]) do
    from..to
    |> Enum.map(&Integer.to_string/1)
    |> Enum.reduce(0, fn x, acc ->
      if valid_password?(x, from, to) do
        acc + 1
      else
        acc
      end
    end)
  end

  defp part_2([from, to]) do
    from..to
    |> Enum.map(&Integer.to_string/1)
    |> Enum.reduce(0, fn x, acc ->
      if valid_password?(x, from, to, 2) do
        acc + 1
      else
        acc
      end
    end)
  end

  def run(input) do
    input |> input_conv() |> part_1() |> IO.inspect()
    input |> input_conv() |> part_2() |> IO.inspect()
  end
end
