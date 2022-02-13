listStr = ["one", "two", "three", "four", "five", "six"]
listInt = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
listAny = [1, "hello", :apple, String]
# all?
# 컬렉션의 모든 요소를 평가
Enum.all?(listStr, fn s -> String.length(s) == 3 end)
|> IO.puts()

Enum.all?(listStr, fn s -> String.length(s) > 1 end)
|> IO.puts()

# any
# 컬랙션의 조건부의 해당하는 아이템이 하나라도 있으면 true
Enum.any?(listStr, fn s -> String.length(s) == 5 end)
|> IO.puts()

# chunk_every
# 컬렉션을 작은 묶음으로 쪼개야 할 경우
Enum.chunk_every(listStr, 2)
|> IO.inspect()

# chunk_by
# 컬렉션을 크기가 아닌 다른 기준에 근거해서 묶는 경우
Enum.chunk_by(listStr, fn x -> String.length(x) end)
|> IO.inspect()

# map_every
# 모든 `n`번 째 아이템을 가져오며, 항상 첫번째 것에도 적용시키는 경우
Enum.map_every(listStr, 2, fn x -> "#{x}!" end)
|> IO.inspect()

Enum.map_every(listInt, 3, fn x -> x + 1000 end)
|> IO.inspect()

# each
# 새로운 값을 만들어내지 않고 콜렉션에 대해 반복하는 것
# each 함수는 :ok라는 애텀을 반환한다.
Enum.each(listStr, fn s -> IO.puts(s) end)
|> IO.inspect()

# map
# 각 아이템마다 함수를 적용해 새로운 컬렉션을 만드는 경우
Enum.map(listInt, fn x -> x - 10 end)
|> IO.inspect()
# <> max
|> Enum.min()
|> IO.puts()

# filter
# true 로 평가되는 아이템들
Enum.filter(listStr, fn x -> String.starts_with?(x, "t") end)
|> IO.inspect()

Enum.filter(listStr, fn x -> String.contains?(x, "e") end)
|> Enum.filter(fn x -> String.length(x) >= 3 end)
|> IO.inspect()

# at
# 리스트 인덱스로 접근
Enum.at(listStr, 0)
|> IO.puts()

# reduce
Enum.reduce([1, 2, 3], 10, fn x, acc -> x + acc end)
|> IO.puts()

Enum.reduce([1, 2, 3], 10, fn x, acc -> x * acc end)
|> IO.puts()

# 축적자를 명시하지 않으면 열거 목록의 첫번 째 요소가 역할을 대신함
Enum.reduce([1, 2, 3], fn x, acc -> x + acc end)
|> IO.puts()

Enum.reduce(["a", "b", "c"], "1", fn x, acc -> acc <> x end)
|> IO.puts()

Enum.reduce(["a", "b", "c"], "1", fn x, acc -> x <> acc end)
|> IO.puts()

# sort
# 컬렉션 정렬,
Enum.sort(listStr)
|> IO.inspect()

Enum.sort(listInt, :desc)
|> IO.inspect()

# Erlang의 Term 순서로 정렬
Enum.sort(listAny)
|> IO.inspect()

# 직접 정렬 함수 만들기
Enum.sort([%{:val => 4}, %{:val => 1}], fn x, y -> x[:val] < y[:val] end)
|> IO.inspect()

# uniq
# 컬랙션 내 중복 내용 지우기
Enum.uniq([1, 2, 3, 2, 1, 1, 1, 1, 1])
|> IO.inspect()

# uniq_by
# 컬랙션 내 중복 내용 지우기, 기준 설정 가능
Enum.uniq_by([%{x: 1, y: 1}, %{x: 2, y: 1}, %{x: 3, y: 3}, %{x: 3, y: 2}], fn coord -> coord.x end)
|> IO.inspect()

Enum.uniq_by([%{x: 1, y: 1}, %{x: 2, y: 1}, %{x: 3, y: 3}, %{x: 3, y: 2}], fn coord -> coord.y end)
|> IO.inspect()

# Capture Operator(&)
# Enum 모듈의 많은 함수들은 넘겨받은 열거 가능한 집합의 각 요소에 작용하는 익명함수를 인수로 받는다.
# 이런 익명함수는 종종 캡처 연산자(&)를 사용해 간결하게 작성할 수 있다.
# [4, 5, 6] 을 만드는 코드. 모두 내부 동작은 같다

# 익명함수에 캡처 연산자 사용하기
# Example 1 (익명함수를 map에 넘기는 구조)
Enum.map([1, 2, 3], fn number -> number + 3 end) |> IO.inspect()

# Example 2 (캡처 연산자로 숫자 리스트의 각 요소를 캡처하고 매핑함수를 통해 전달될 때 &1에 각 요소를 할당)
Enum.map([1, 2, 3], &(&1 + 3)) |> IO.inspect()

# Example 3 (캡처 연산자를 미리 익명함수 변수에 할당하고 map 함수에서 호출 할 수 있게끔 구성)
plus_three_a = &(&1 + 3)
Enum.map([1, 2, 3], plus_three_a) |> IO.inspect()

# 이름있는 함수에 캡처 연산자 사용하기
# Example 1 (이름있는 함수를 map에 넘기는 구조)
defmodule Adding do
  def plus_three(number), do: number + 3
end

Enum.map([10, 11, 12], fn number -> Adding.plus_three(number) end) |> IO.inspect()

# Example 2 (캡처 연산자 활용)
Enum.map([10, 11, 12], &Adding.plus_three(&1)) |> IO.inspect()

# Example 3 (명시적으로 변수를 캡처하지 않고 이름있는 함수를 직접 호출해 간결하게 사용하기)
Enum.map([10, 11, 12], &Adding.plus_three/1) |> IO.inspect()
