defmodule Day10 do
  @char_of_asteroid "#"
  @char_of_my_location "X"

  def str_to_list(str),
    do: str |> Enum.map(fn line -> line |> String.trim() |> String.graphemes() end)

  def list_to_ast_list(list) do
    for y <- 0..get_height(list),
        x <- 0..get_width(list),
        get(list, x, y) === @char_of_asteroid do
      %{x: x, y: y}
    end
  end

  def find_my_location(list) do
    for y <- 0..get_height(list),
        x <- 0..get_width(list),
        get(list, x, y) === @char_of_my_location do
      %{x: x, y: y}
    end
  end

  def part_1(str) do
    bases = str |> str_to_list() |> list_to_ast_list()

    bases
    |> Enum.map(fn base ->
      get_monitoring_cnt(base, bases, :sets.new())
    end)
    |> Enum.max()
    |> IO.inspect()
  end

  def part_2(str) do
    list = str |> str_to_list()
    base = list |> find_my_location()
    targets = list |> list_to_ast_list()

    targets
    |> Enum.map(fn target ->
      get_monitoring_cnt(base, target, :sets.new())
    end)

    # |> get_radians()
  end

  def get(list, x, y), do: Enum.at(list, y) |> Enum.at(x)
  def get_height(list), do: length(list) - 1
  def get_width(list), do: length(Enum.at(list, 0))

  def offer(h, t) do
    [h | t]
  end

  def poll([h | t]), do: {h, t}
  def poll([]), do: {nil, []}

  def same?(me, target), do: me.x == target.x && me.y == target.y

  def get_radian(base, target), do: :math.atan2(target.x - base.x, target.y - base.y)

  def get_degree(base, target) do
    get_radian(base, target) * 180 / :math.pi()
  end

  def get_radians(base, targets) do
    targets
    |> Enum.map(fn e ->
      %{e | radian: get_radian(base, e)}
    end)
  end

  def get_monitoring_cnt(_, [], set), do: :sets.size(set)

  def get_monitoring_cnt(me, others, set) do
    {target, tail} = others |> poll()

    if same?(me, target) do
      get_monitoring_cnt(me, tail, set)
    else
      radian = get_radian(me, target)
      get_monitoring_cnt(me, tail, :sets.add_element(radian, set))
    end
  end

  def add_custom_set(list, element) do
    cnt = Enum.count(list, &(&1.radian == element.radian))

    if cnt > 0 do
      [list | element]
    else
      list
    end
  end
end

File.stream!("inputs/10.txt") |> Day10.part_1()
# File.stream!("inputs/10.txt") |> Day10.part_2()

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
# 왼쪽 방향
target_left = %{x: 1, y: 2}
# 아래쪽 방향
target_down = %{x: 2, y: 3}

Day10.get_radian(base, target_up) |> IO.inspect()
Day10.get_radian(base, target_up2) |> IO.inspect()
Day10.get_radian(base, target_up_right) |> IO.inspect()
Day10.get_radian(base, target_up_right2) |> IO.inspect()
Day10.get_radian(base, target_right) |> IO.inspect()
Day10.get_radian(base, target_down) |> IO.inspect()
Day10.get_radian(base, target_left) |> IO.inspect()

tmp = [%{x: 1, y: 2}, %{x: 2, y: 2}]
tmp |> IO.inspect()
Enum.member?(tmp, %{x: 1}) |> IO.inspect()
Enum.count(tmp, fn e -> e.y == 2 end) |> IO.inspect()
