# 매치 연산자 (=)
# 매치 연산자의 좌변에서 변수가 포함되어 있을 경우 값의 대입이 일어난다.
# 매치 연산자를 사용하면 전체 표현식이 방정식으로 변경된다.
# 매치가 성공되면 방정식의 값을 반환하고 그렇지 않을경우 에러를 발생시킨다.
x = 1
# 성공
1 = x
# 2 = x # 실패

# 매치 연산자 - 리스트
list = [1, 2, 3]
[1 | tail] = list
IO.inspect(tail)
[1, 2 | tail] = list
IO.inspect(tail)

# 패치 연산자 - 튜플
{:ok, value} = {:ok, "Successful!"}
IO.puts(value)
# No Match!
# {:ok, value} = {:error}

# 핀 연산자 (^)
# 매치 연산자에 의해 변수에게 값의 대입이 일어날 때 변수에 새로운 값이 대입되는걸 원치 않은 경우 사용하는 것
# 핀연산자를 사용해 변수를 고정시키면 변수에 새 값을 대입시키지 않고 기존의 값과 매칭하게 됨
x = 1
# ^x = 2 # Error
{x, ^x} = {2, 1}
IO.puts(x)

# 맵에서의 사용
key = "hello"
%{^key => value} = %{"hello" => "world"}
|> IO.inspect()
IO.puts(value)

# 함수의 절에대한 핀 연산자
greeting = "Hello"
greet = fn
  (^greeting, name) -> "Hi #{name}" # :1
  (greeting, name) -> "#{greeting}, #{name}" # :2
end

greet.("Hello", "Benn") # goto :1
|> IO.puts()

greet.("Nice", "Benn~") # goto :2
|> IO.puts()
