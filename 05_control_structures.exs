# if와 unless
# Elixir에서는 nil과 false만 거짓으로 간주된다.
# 위 문법은 언어 구조가 아닌 매크로로서 정의되어 있다.

# if
if String.valid?("Hello") do
  "Valid string!"
else
  "Invalid string."
end
|> IO.puts()

# => true
if "a string value" do
  "Truthy"
end
|> IO.puts()

# unless
unless is_integer("hello") do
  "Not an Int"
end
|> IO.puts()

# case
# 여러 패턴에 매칭해야하는 경우
case {:ok, "Hello World"} do
  {:ok, result} -> result
  {:error} -> "Uh oh!"
  _ -> "Catch all"
end
|> IO.puts()

# _ 변수를 사용하지 않으면 일치하는 패턴이 존재하지 않을 때 오류가 발생하니 처리해줘야 한다.
# _ 를 그 외의 모든 것에 매칭되는 else 처럼 생각하면 된다.
# case는 패턴 패칭에 의존하기 때문에 같은 규칙과 제약이 모두 적용된다.
case :even do
  :odd -> "Odd"
  _ -> "Not Odd"
end
|> IO.puts()

# 기존의 변수에 매칭하고자 한다면 핀 연산자를 사용하면 된다.
pie = 3.14

case "cherry pie" do
  ^pie -> "Not so tasty"
  pie -> "I bet #{pie} is tasty"
end
|> IO.puts()

# 가드 구문을 지원한다
case {1, 2, 3} do
  {1, x, 3} when x > 0 ->
    "Will match"

  _ ->
    "Won't match"
end
|> IO.puts()

case {1, 2, 3} do
  {1, x, 3} when x == 0 ->
    "Will match"

  _ ->
    "Won't match"
end
|> IO.puts()

# cond
# 값이 아닌 조건식에 매칭하는 경우
# 다른 언어의 else if와 유사
cond do
  2 + 2 == 5 ->
    "This will not be true"

  2 * 2 == 3 ->
    "Nor this"

  1 + 1 == 2 ->
    "But this will"
end
|> IO.puts()

defmodule SignCheker do
  def run(sign) do
    len = String.length(sign)

    cond do
      len > 0 -> "better then 0"
      len < 0 -> "smaller then 0"
      len == 0 -> "is 0"
    end
  end
end

SignCheker.run("hello")
|> IO.puts()

SignCheker.run("")
|> IO.puts()

# case 와 마찬가지로 cond 도 일치하는 식이 없는 경우를 처리해줘야 하는데 이를 true로 처리한다.
cond do
  7 + 1 == 0 -> "Incorrect"
  true -> "Catch all"
end
|> IO.puts()

# with
# 중첩된 case/2 구문이 쓰일만한 곳이나 깔끔하게 파이프 연산을 할 수 없는 상황에서 유용하다.
user = %{first: "Sean", last: "Callan"}

# <-의 오른쪽을 왼쪽과 비교하기 위해 패턴 매칭을 사용한다
with {:ok, first} <- Map.fetch(user, :first),
     {:ok, last} <- Map.fetch(user, :last),
     do:
       (last <> ", " <> first)
       |> IO.puts()

# 매치가 실패된 경우 :error 애텀이 반환
user = %{first: "doomspork"}

with {:ok, first} <- Map.fetch(user, :first),
     {:ok, last} <- Map.fetch(user, :last),
     do:
       (last <> ", " <> first)
       |> IO.inspect()

# else 구문 사용 가능
import Integer

m = %{a: 1, c: 3}

a =
  with {:ok, res} <- Map.fetch(m, :a),
       true <- is_even(res) do
    IO.puts("Divided by 2 it is #{div(res, 2)}")
    :even
  else
    :error ->
      IO.puts("We don't have this item in map")
      :error

    _ ->
      IO.puts("It's not odd")
      :odd
  end
|> IO.inspect()
