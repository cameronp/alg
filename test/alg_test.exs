defmodule AlgTest do
  use ExUnit.Case
  doctest Alg

  test "greets the world" do
    assert Alg.hello() == :world
  end
end
