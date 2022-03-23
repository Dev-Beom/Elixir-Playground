defmodule Computer.Utils do
  def strs_to_ints(strs) do
    strs
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end

  def list_to_map(list) do
    0..length(list)
    |> Stream.zip(list)
    |> Enum.into(%{})
  end
end

defmodule Computer.Permutation do
  def of([]), do: [[]]
  def of(list), do: for(head <- list, tail <- of(list -- [head]), do: [head | tail])
end
