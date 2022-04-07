defmodule Day10 do
  @char_of_asteroid "#"

  def str_to_list(str),
    do: str |> Enum.map(fn line -> line |> String.trim() |> String.graphemes() end)

  def list_to_ast_list(list) do
    for y <- 0..get_height(list),
        x <- 0..get_width(list),
        get(list, x, y) === @char_of_asteroid do
      %{x: x, y: y}
    end
  end

  def part_1(str) do
    bases = str |> str_to_list() |> list_to_ast_list()

    bases
    |> Enum.map(fn base ->
      get_monitoring_cnt(base, bases)
    end)
    |> Enum.max_by(fn e -> e.count end)
    |> IO.inspect()
  end

  def part_2(str) do
    list = str |> str_to_list()
    base = part_1(str)
    targets = list |> list_to_ast_list()

    result =
      get_radians(base, targets)
      |> Enum.sort_by(& &1.radian, :desc)
      |> find_deleted_ast_by_idx(base, 200, 1)
      |> IO.inspect()

    IO.inspect(result.x * 100 + result.y)
  end

  def find_deleted_ast_by_idx([head | tails] = list, base, find_idx, curr_idx) do
    # 현재와 다음의 라디언이 같은경우
    # 베이스보다 가장 가가운 라디언을 찾아서 제거
    if find_idx === curr_idx do
      head
    end

    if head.radian === hd(tails).radian do
      rebased_list = rebase_minimun_distance_ast(tails, base, head)
      find_deleted_ast_by_idx(rebased_list, base, find_idx, curr_idx)
    else
      if find_idx === curr_idx do
        head
      else
        find_deleted_ast_by_idx(tails, base, find_idx, curr_idx + 1)
      end
    end
  end

  # 같은 각도에 위치한 행성 중 가장 가까운 행성을 제외하고 리스트의 맨 뒤로 보냅니다.
  def rebase_minimun_distance_ast([head | tails] = list, base, curr_min_ast) do
    if head.radian != hd(tails).radian do
      list
    else
      if get_distance(base, curr_min_ast) > get_distance(base, head) do
        rebase_minimun_distance_ast(tails ++ [curr_min_ast], base, head)
      else
        rebase_minimun_distance_ast(tails ++ [head], base, curr_min_ast)
      end
    end
  end

  def get(list, x, y), do: Enum.at(list, y) |> Enum.at(x)
  def get_height(list), do: length(list) - 1
  def get_width(list), do: length(Enum.at(list, 0))

  def poll([h | t]), do: {h, t}
  def poll([]), do: {nil, []}

  def same?(me, target), do: me.x == target.x && me.y == target.y

  def get_radian(base, target), do: :math.atan2(target.x - base.x, target.y - base.y)

  def get_distance(base, target),
    do: :math.sqrt(:math.pow(abs(target.x - base.x), 2) + :math.pow(abs(target.y - base.y), 2))

  # base.x = A, base.y = B, target.x = C, target.y = D
  # Math.sqrt( Math.pow( Math.abs(C - A), 2 ) + Math.pow( Math.abs(D - B), 2 ) )

  def get_radians(base, targets),
    do: targets |> Enum.map(&Map.put(&1, :radian, get_radian(base, &1)))

  def get_monitoring_cnt(_, [], list),
    do: %{count: length(list), x: Enum.at(list, 0).x, y: Enum.at(list, 0).y}

  def get_monitoring_cnt(me, others), do: get_monitoring_cnt(me, others, [])

  def get_monitoring_cnt(me, others, list) do
    {target, tail} = others |> poll()

    if same?(me, target) do
      get_monitoring_cnt(me, tail, list)
    else
      radian = get_radian(me, target)
      list = add_custom_set(list, Map.put(me, :radian, radian))
      get_monitoring_cnt(me, tail, list)
    end
  end

  def add_custom_set(list, element) when length(list) == 0, do: [element | list]

  def add_custom_set(list, element) when length(list) > 0 do
    cond do
      Enum.count(list, &(&1.radian == element.radian)) > 0 -> list
      true -> [element | list]
    end
  end
end

# File.stream!("inputs/10.txt") |> Day10.part_1()
File.stream!("inputs/10.txt") |> Day10.part_2()

base = %{x: 2, y: 2}

# 위쪽 방향
target_up = %{x: 2, y: 1}
target_up2 = %{x: 2, y: 0}
# 위 오른쪽 방향
target_up_right = %{x: 3, y: 1}
target_up_right2 = %{x: 4, y: 1}
target_up_right2 = %{x: 10, y: 1}
# 오른쪽 방향
target_right = %{x: 3, y: 2}
# 아래쪽 방향
target_down = %{x: 2, y: 3}
# 왼쪽 방향
target_left = %{x: 1, y: 2}
target_left_up = %{x: 1, y: 1}

Day10.get_radian(base, target_up) |> IO.inspect()
Day10.get_radian(base, target_up2) |> IO.inspect()
Day10.get_radian(base, target_up_right) |> IO.inspect()
Day10.get_radian(base, target_up_right2) |> IO.inspect()
Day10.get_radian(base, target_right) |> IO.inspect()
Day10.get_radian(base, target_down) |> IO.inspect()
Day10.get_radian(base, target_left) |> IO.inspect()
Day10.get_radian(base, target_left_up) |> IO.inspect()
