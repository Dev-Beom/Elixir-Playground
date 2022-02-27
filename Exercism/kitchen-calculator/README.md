# Kitchen Calculator

Welcome to Kitchen Calculator on Exercism's Elixir Track.
If you need help running the tests or submitting your code, check out `HELP.md`.
If you get stuck on the exercise, check out `HINTS.md`, but try and solve it without using those first :)

## Introduction

## Tuples

In Elixir, a tuple is a data structure which organizes data, holding a fixed number of items of any type, but without explicit names for each element. Tuples are often used in Elixir for memory read-intensive operations, since read-access of an element is a constant-time operation. They are not usually used when elements may need to be added/removed dynamically because rather than modifying the existing tuple, a new tuple is created which requires memory to be allocated upfront.

In practice, tuples are created in Elixir using curly braces. Elements in a tuple can be individually accessed using the `elem/2` function using 0-based indexing:

```elixir
empty_tuple = {}
one_element_tuple = {1}
multiple_element_tuple = {1, :a, "hello"}

elem(multiple_element_tuple, 2)
# => "hello"
```

### Tuples as grouped information

Tuples are often used in practice to represent grouped information.

```elixir
Float.ratio(0.25)
# => {1, 4} indicating the numerator and denominator of the fraction ¼
```

## Pattern Matching

The use of pattern matching is dominant in assertive, idiomatic Elixir code. You might recall that `=/2` is described as a match operator rather than as an assignment operator. When using the match operator, if the pattern on the left matches the right, any variables on the left are bound, and the value of the right side is returned. A `MatchError` is raised if there is no match.

```elixir
2 = 2
# => 2
# Literals can be matched if they are the same

2 = 3
# => ** (MatchError) no match of right hand side value: 3

{_, denominator} = Float.ratio(0.25)
# => {1, 4}
# the variable `denominator` is bound to the value 4
```

Remember, matches occur from the right side to the left side.

In the last example if we don't need a variable in a pattern match, we can discard it by referencing `_`. Any variable starting with an `_` is not tracked by the runtime.

### Pattern matching in named functions

Pattern matching is also a useful tool when creating multiple function clauses. Pattern matching can be used on the functions' arguments which then determines which function clause to invoke -- starting from the top of the file down until the first match. Variables may be bound in a function head and used in the function body.

```elixir
defmodule Example do
  def named_function(:a = variable_a) do
    {variable_a, 1}
  end

  def named_function(:b = variable_b) do
    {variable_b, 2}
  end
end

Example.named_function(:a)
# => {:a, 1}

Example.named_function(:b)
# => {:b, 2}

Example.named_function(:c)
# => ** (FunctionClauseError) no function clause matching in Example.named_function/1
```

## Instructions

While preparing to bake cookies for your friends, you have found that you have to convert some of the measurements used in the recipe. Being only familiar with the metric system, you need to come up with a way to convert common US baking measurements to milliliters (mL) for your own ease.

친구들을 위해 쿠키 굽기를 준비하는 동안, 여러분은 레시피에 사용된 측정치 중 일부를 변환해야 한다는 것을 알게 되었습니다.
미터법에만 익숙하기 때문에, 여러분은 자신의 편의를 위해 일반적인 미국 베이킹 측정값을 밀리리터(mL)로 변환하는 방법을 생각해내야 합니다.

Use this conversion chart for your solution:
솔루션에 대해 다음 변환 차트를 사용합니다.

| Unit to convert | volume | in milliliters (mL) |
| --------------- | ------ | ------------------- |
| mL              | 1      | 1                   |
| US cup          | 1      | 240                 |
| US fluid ounce  | 1      | 30                  |
| US teaspoon     | 1      | 5                   |
| US tablespoon   | 1      | 15                  |

Being a talented programmer in training, you decide to use milliliters as a transition unit to facilitate the conversion from any unit listed to any other (even itself).

교육에 뛰어난 프로그래머인 귀하는 밀리리터를 전환 단위로 사용하여 목록에 있는 모든 단위에서 다른 단위(자체)로 쉽게 전환할 수 있도록 결정했습니다.

## 1. Get the numeric component from a volume-pair

Implement the `KitchenCalculator.get_volume/1` function. Given a volume-pair tuple, it should return just the numeric component.
'KitchenCalculator.get_volume/1' 함수를 구현합니다. 볼륨 쌍 튜플이 지정되면 숫자 구성 요소만 반환해야 합니다.

```elixir
KitchenCalculator.get_volume({:cup, 2.0})
# => 2.0
```

## 2. Convert the volume-pair to milliliters

Implement the `KitchenCalculator.to_milliliter/1` function. Given a volume-pair tuple, it should convert the volume to milliliters using the conversion chart.

Use multiple function clauses and pattern matching to create the functions for each unit. The atoms used to denote each unit are: `:cup`, `:fluid_ounce`, `:teaspoon`, `:tablespoon`, `:milliliter`. Return the result of the conversion wrapped in a tuple.

```elixir
KitchenCalculator.to_milliliter({:cup, 2.5})
# => {:milliliter, 600.0}
```

## 3. Convert the milliliter volume-pair to another unit

Implement the `KitchenCalculator.from_milliliter/2` function. Given a volume-pair tuple and the desired unit, it should convert the volume to the desired unit using the conversion chart.

Use multiple function clauses and pattern matching to create the functions for each unit. The atoms used to denote each unit are: `:cup`, `:fluid_ounce`, `:teaspoon`, `:tablespoon`, `:milliliter`

```elixir
KitchenCalculator.from_milliliter({:milliliter, 1320.0}, :cup)
# => {:cup, 5.5}
```

## 4. Convert from any unit to any unit

Implement the `KitchenCalculator.convert/2` function. Given a volume-pair tuple and the desired unit, it should convert the given volume to the desired unit.

```elixir
KitchenCalculator.convert({:teaspoon, 9.0}, :tablespoon)
# => {:tablespoon, 3.0}
```

## Source

### Created by

- @neenjaw

### Contributed to by

- @angelikatyborska