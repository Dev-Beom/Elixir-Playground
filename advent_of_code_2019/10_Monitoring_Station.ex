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

    get_radians(base, targets)
    |> Enum.sort_by(fn e -> e.radian end, :desc)
    |> IO.inspect()
  end

  def get(list, x, y), do: Enum.at(list, y) |> Enum.at(x)
  def get_height(list), do: length(list) - 1
  def get_width(list), do: length(Enum.at(list, 0))

  def poll([h | t]), do: {h, t}
  def poll([]), do: {nil, []}

  def same?(me, target), do: me.x == target.x && me.y == target.y

  def get_radian(base, target), do: :math.atan2(target.x - base.x, target.y - base.y)

  def get_degree(base, target) do
    get_radian(base, target) * 180 / :math.pi()
  end

  def get_radians(base, targets) do
    targets
    |> Enum.map(&Map.put(&1, :radian, get_radian(base, &1)))
  end

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
    cnt = Enum.count(list, &(&1.radian == element.radian))

    if cnt > 0 do
      list
    else
      [element | list]
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
