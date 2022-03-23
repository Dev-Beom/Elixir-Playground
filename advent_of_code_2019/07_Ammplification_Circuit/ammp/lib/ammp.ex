defmodule Day7 do
  alias Computer.Controller
  alias Computer.Permutation
  alias Computer.Utils

  def part_1 do
    memory =
      File.read!("lib/07.txt")
      |> Utils.strs_to_ints()
      |> Utils.list_to_map()

    0..4
    |> Enum.to_list()
    |> Permutation.of()
    |> Enum.map(&Controller.excute(memory, &1))
    |> Enum.max()
  end
end


