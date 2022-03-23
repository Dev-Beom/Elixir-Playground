# List
list = [3.14, :pie, "Apple"]

# 빠름
["pie" | list]
|> IO.inspect()

# 느림
(list ++ ["yb"])
|> IO.inspect()

list = [1, 2] ++ [3, 4, 1]
IO.inspect(list)

# 리스트 빼기
list = ["foo", :bar, 42] -- [42, "bar"]
IO.inspect(list)

# 오른쪽에 있는 모든 요소에 대해 왼쪽에서 처음 만난 요소만 지운다.
list = [1, 2, 2, 3, 2, 3] -- [1, 2, 3, 2]
IO.inspect(list)

# 엄격한 비교 2 != 2.0
list = [2] -- [2.0]
IO.inspect(list)

# Head/Tail
# 맨 첫 번째 원소
head = hd([3.14, :pie, "apple"])
IO.inspect(head)

# 맨 첫번째 원소를 뺀 나머지 원소
tail = tl([3.14, :pie, "apple"])
IO.inspect(tail)

# 다음과 같이 cons 연산자'|'과 패턴 매칭을 활용한 표현도 가능
[head | tail] = [3.14, :pie, "apple"]
IO.inspect([head, tail])

# Tuples
# 메모리 연속 저장, 길이 구하기 빠름 but 수정비용 비쌈 -> 새로운 튜플 생성시 통째로 메모리 복사 때문
IO.inspect({3.14, :pie, "apple"})
# 튜플은 함수가 추가 정보를 반환하는 수단으로 자주 사용

# Keyword List, 키워드 리스트
# 첫번째 원소가 애텀이고 2개의 원소를 가지는 특별한 `튜플들의 리스트`, 리스트와 성능이 비슷
#  **주요 특징**
#  * 모든 키는 애텀
#  * 키는 정렬되어있음
#  * 키는 유일하지 않아도 됨
#   위와같은 특징으로 `함수에 옵션을 전달하는 데` 가장 많이 사용됨
IO.puts([{:trim, true}] == [trim: true])

# 값 접근 방법
list = [aaa: "111", bbb: "222"]
IO.puts(list[:aaa])

# 뒤에 값 추가
list = list ++ [ccc: "333"]
IO.inspect(list)

# 앞에 값 추가
list = [xxx: "000"] ++ list
IO.inspect(list)

IO.puts(list[:xxx])
# 중복 값 추가
list = [xxx: "001"] ++ list
IO.inspect(list)
# 중복 키의 경우 앞에 추가된 값을 조회
IO.puts(list[:xxx])

# 맵
# 키워드 리스트와는 다르게 맵의 키는 어떤 타입이든 될 수 있고 순서를 따르지 않음.
# %{} 문법을 이용해 정의할 수 있음.

map = %{
  :aaa => "111",
  "222" => :bbb
}

IO.inspect(map)
IO.puts(map[:aaa])
IO.puts(map["222"])

# 중복된 키 추가시 기존 값 교체
# overridden
IO.inspect(%{:aaa => "111", :aaa => "222"})

# 변수를 맵의 키로 사용 가능
key = "aaa"
IO.inspect(%{key => 111})

# 모든 키가 애텀인 맵을 정의하기 위한 특별한 문법
map = %{aaa: "111", bbb: "222"}
same_map = %{:aaa => "111", :bbb => "222"}
IO.puts(map == same_map)

# 애텀 키 접근
map = %{aaa: "111", bbb: "222"}
IO.puts(map.aaa)

# 맵의 특정 부분을 갱신하기 위한 독자적인 문법, but 새로운 맵을 생성하는 것
map = %{aaa: "111", bbb: "222"}
IO.inspect(%{map | aaa: "000"})

# 새로운 키를 만드는 방법
map = Map.put(map, :ccc, "333")
IO.inspect(map)
