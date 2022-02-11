listStr = ["one", "two", "three", "four", "five", "six"]
listInt = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
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
|> Enum.min()
|> IO.puts()

#
