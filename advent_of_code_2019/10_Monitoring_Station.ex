# 탄젠트 계산
# https://spiralmoon.tistory.com/entry/%ED%94%84%EB%A1%9C%EA%B7%B8%EB%9E%98%EB%B0%8D-%EC%9D%B4%EB%A1%A0-%EB%91%90-%EC%A0%90-%EC%82%AC%EC%9D%B4%EC%9D%98-%EC%A0%88%EB%8C%80%EA%B0%81%EB%8F%84%EB%A5%BC-%EC%9E%AC%EB%8A%94-atan2

# 1. 개행으로 문자 나누기
# 2. 2중 포문(x, y)으로 읽어가면서 .이 아니고 #이면 좌표값 맵에 데이터 넣기
# key: index, value: {x, y}

# 3. visited 배열 만들기  - 여기는 방문한 각도를 넣을 것
# 배열말고 set으로 할까
# 4. 중앙부터 전파하면서 level을 + 1씩 해서 찾기

# 가령 기준점 x=3,y=3, level=1 이면 ㄱ

# {x-level, y}, {x+level, y} = {2, 3}, {4, 3} ㄴ
# {x, y-level}, {x, y+level} = {3, 2}, {3, 4} ㄴ
# {x-level, y-level}, {x+level, y+level} = {2, 2}, {4, 4} ㄷ
# {x-level, y+level}, {x+level, y-level} = {2, 4}, {4, 2} ㄷ

# ㅁㅁㅁㅁㅁㅁ
# ㅁㅁㅁㅁㅁㅁ
# ㅁㅁㄷㄴㄷㅁ
# ㅁㅁㄴㄱㄴㅁ
# ㅁㅁㄷㄴㄷㅁ
# ㅁㅁㅁㅁㅁㅁ

# x=3, y=3, level=2이면 ㄱ

# {x-level, y}, {x+level, y} = {1, 3}, {5, 3} ㄴ
# {x, y-level}, {x, y+level} = {3, 1}, {3, 5} ㄴ
# {x-level, y-level}, {x+level, y+level} = {1, 1}, {5, 5} ㄷ
# {x-level, y+level}, {x+level, y-level} = {1, 5}, {5, 1} ㄷ

# ㅁㅁㅁㅁㅁㅁ
# ㅁㄷㅁㄴㅁㄷ
# ㅁㅁㅁㅁㅁㅁ
# ㅁㄴㅁㄱㅁㄴ
# ㅁㅁㅁㅁㅁㅁ
# ㅁㄷㅁㄴㅁㄷ

# 너무 귀찮아진다.
# 생각해보니 이렇게 까지 안해도 바로 확인하면 가능
# 어차피 유일한 1개의 숫자만 뽑으면 됨.

# 2번문제에서 여러개 찾아야 하는건
# 여러개 넣고 가장 거리가 짧은걸 체크하고 날려버리면 된다.

# 일단 모두 각도를 계산하고 넣는다.
# 그리고 각도로 정렬한다.
# 같은 각도로 있는 친구들을 위해 배열로 넣는다.
# [
#     %{x: x, y: y, radian: radian, isBoom: false},
#     %{x: x, y: y, radian: radian, isBoom: false},
#     %{x: x, y: y, radian: radian, isBoom: false},
#     %{x: x, y: y, radian: radian, isBoom: false}...
# ]

# 여기서 중복된 각도를 갖고있으면
# x, y 절댓값 거리가 X 보다 가까운 친구를 isBoom 시킨다.
defmodule Day10 do
  defp str_to_list(str),
    do: str |> Enum.map(fn line -> line |> String.trim() |> String.graphemes() end)

  @asteroid "#"
  defp list_to_ast_list(list) do
    for y <- 0..get_height(list),
        x <- 0..get_width(list),
        get(list, x, y) === @asteroid do
      %{x: x, y: y}
    end
  end

  def run(str) do
    base =
      str
      |> str_to_list()
      |> list_to_ast_list()

    base
    |> Enum.map(fn me ->
      get_monitoring_cnt(me, base, :sets.new())
    end)
    |> Enum.max()
    |> IO.inspect()
  end

  defp get(list, x, y), do: Enum.at(list, y) |> Enum.at(x)
  defp get_height(list), do: length(list) - 1
  defp get_width(list), do: length(Enum.at(list, 0))

  defp offer(h, t) do
    [h | t]
  end

  defp poll([h | t]), do: {h, t}
  defp poll([]), do: {nil, []}

  defp same?(me, target), do: me.x == target.x && me.y == target.y

  defp get_radian(base, target), do: :math.atan2(target.x - base.x, target.y - base.y)

  defp get_monitoring_cnt(_, [], set), do: :sets.size(set)

  defp get_monitoring_cnt(me, others, set) do
    {target, tail} = others |> poll()

    if same?(me, target) do
      get_monitoring_cnt(me, tail, set)
    else
      radian = get_radian(me, target)
      get_monitoring_cnt(me, tail, :sets.add_element(radian, set))
    end
  end
end

File.stream!("inputs/10.txt") |> Day10.run()
