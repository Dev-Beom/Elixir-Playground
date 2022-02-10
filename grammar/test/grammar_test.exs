defmodule GrammarTest do
  use ExUnit.Case
  doctest Grammar

  test "greets the world" do
    assert Grammar.hello() == :world
  end
end
