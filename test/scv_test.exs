defmodule ScvTest do
  use ExUnit.Case
  doctest Scv

  test "greets the world" do
    assert Scv.hello() == :world
  end
end
