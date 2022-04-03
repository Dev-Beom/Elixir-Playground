# 탄젠트 계산
# https://spiralmoon.tistory.com/entry/%ED%94%84%EB%A1%9C%EA%B7%B8%EB%9E%98%EB%B0%8D-%EC%9D%B4%EB%A1%A0-%EB%91%90-%EC%A0%90-%EC%82%AC%EC%9D%B4%EC%9D%98-%EC%A0%88%EB%8C%80%EA%B0%81%EB%8F%84%EB%A5%BC-%EC%9E%AC%EB%8A%94-atan2

defmodule Day10 do
  defp str_to_list(str),
    do: str |> Enum.map(fn line -> line |> String.trim() |> String.graphemes() end)

  @asteroid "#"
  defp list_to_ast_list(list) do
    for y <- 0..get_height(list),
        x <- 0..get_width(list),
        get(list, x, y) === @asteroid do
      %{x: x, y: y, cnt: 0}
    end
  end

  defp get_moditoring_cnt(me, [], set), do: :sets.size(set)

  defp get_monitoring_cnt(me, others, set) do
    :sets.add()
    :math.atan2()
  end

  def run(str) do
    {a, t} =
      str
      |> str_to_list()
      |> list_to_ast_list()
      |> poll()

    {b, t2} = t |> poll()

    x = b.x - a.x
    y = b.y - a.y
    radian = :math.atan2(x, y)

    degree = radian * 180 / :math.pi()
    IO.inspect("#{radian}, #{degree}")

    # {h, t} =
    #   str
    #   |> str_to_list()
    #   |> list_to_ast_list()
    #   |> IO.inspect()
    #   |> poll()
    #   |> IO.inspect()

    # h.x |> IO.inspect()
  end

  def generate_context() do
    %{asteroids: []}
  end

  defp get(list, x, y), do: Enum.at(list, y) |> Enum.at(x)
  defp get_height(list), do: length(list) - 1
  defp get_width(list), do: length(Enum.at(list, 0))

  defp offer(h, t) do
    [h | t]
  end

  defp poll([h | t]), do: {h, t}
  defp poll([]), do: {nil, []}
end

File.stream!("inputs/10.txt") |> Day10.run()
# set = :sets.new()

# set = :sets.add_element(1, set)
# set = :sets.add_element(2, set)
# set = :sets.add_element(3, set)
# set = :sets.add_element(4, set)
# set = :sets.add_element(5, set)

# IO.inspect(set)
# :sets.size(set) |> IO.inspect()
