defmodule Math do
  def gcd(a, 0), do: a

  def gcd(a, b) do
    cond do
      a < b -> gcd(b, a)
      true -> gcd(b, rem(a, b))
    end
  end

  def lcm(a, b), do: div(a * b, gcd(a, b))
end

defmodule Day12 do
  @input [{5, 13, -3}, {18, -7, 13}, {16, 3, 4}, {0, 8, 8}]
  @part1_steps 1000

  @doc """
  시스템의 전체 에너지 계산
  """
  def part1 do
    simulate(@input, @part1_steps)
    |> total_energy()
  end

  @doc """
  Find the period of the system
  """
  def part2 do
    get_lcm(@input)
  end

  @doc """
  시스템의 총 에너지 계산
  """
  def total_energy({system, _acc}) do
    IO.inspect(system)
    Enum.reduce(system, 0, fn {v, p}, acc -> acc + energy(v) * energy(p) end)
  end

  defp energy({x, y, z}), do: abs(x) + abs(y) + abs(z)

  @doc """
  여러 단계에 대한 시스템 시뮬레이션
  """
  def simulate(pos, steps) do
    # [
    #   {{5, 13, -3}, {0, 0, 0}},
    #   {{18, -7, 13}, {0, 0, 0}},
    #   {{16, 3, 4}, {0, 0, 0}},
    #   {{0, 8, 8}, {0, 0, 0}}
    # ]
    steps |> IO.inspect()
    start = Enum.zip(pos, Stream.cycle([{0, 0, 0}]))
    calculation(start, steps, [start])
  end

  defp calculation(pos, 0, acc), do: {pos, Enum.reverse(acc)}

  defp calculation(pos, steps, acc) do
    new_pos =
      Enum.map(pos, &gravity(&1, pos, &1))
      |> Enum.map(&velocity(&1))

    calculation(new_pos, steps - 1, [new_pos | acc])
  end

  # 속도
  defp velocity({{x, y, z}, v = {vx, vy, vz}}) do
    {{x + vx, y + vy, z + vz}, v}
  end

  # 중력
  defp gravity(_, [], acc), do: acc

  defp gravity(
         curr = {{cx, cy, cz}, _},
         [{{px, py, pz}, _} | tail],
         {pos, {nx, ny, nz}}
       ) do
    new_x = pulling(cx, px)
    new_y = pulling(cy, py)
    new_z = pulling(cz, pz)
    gravity(curr, tail, {pos, {nx + new_x, ny + new_y, nz + new_z}})
  end

  defp pulling(curr, prev) do
    cond do
      curr < prev -> 1
      curr > prev -> -1
      true -> 0
    end
  end

  def get_lcm(position) do
    {_, acc} = simulate(position, 500_000)
    x = axis_repeat(0, acc)
    y = axis_repeat(1, acc)
    z = axis_repeat(2, acc)
    Math.lcm(x, Math.lcm(y, z))
  end

  def axis_repeat(index, acc) do
    [head | tails] = axis(index, acc)
    Enum.find_index(tails, &(&1 == head)) + 1
  end

  def axis(index, acc) do
    Enum.map(acc, &get_nth(&1, index))
  end

  defp get_nth(acc, index) do
    # [{205, -6}, {-224, 1}, {32, -2}, {26, 7}]
    Enum.map(acc, fn {p, v} -> {elem(p, index), elem(v, index)} end)
  end
end

Day12.part1() |> IO.inspect()
Day12.part2() |> IO.inspect()
