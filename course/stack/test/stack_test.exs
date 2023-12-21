defmodule StackTest do
  use ExUnit.Case
  doctest Stack

  test "start_link" do
    {:ok, pid} = Stack.start_link()
    assert Stack.get(pid) === []

    {:ok, pid} = Stack.start_link(initial_state: [123])
    assert Stack.get(pid) === [123]

    Stack.start_link(initial_state: [321], name: NamedStack)
    assert Stack.get(NamedStack) === [321]
  end

  test "push & pop" do
    {:ok, pid} = Stack.start_link()
    assert Stack.get(pid) === []

    assert Stack.pop(pid) === nil
    assert Stack.get(pid) === []

    Stack.push(pid, 1)
    assert Stack.get(pid) === [1]
    Stack.push(pid, 2)
    assert Stack.get(pid) === [2, 1]

    assert Stack.pop(pid) === 2
    assert Stack.get(pid) === [1]
    assert Stack.pop(pid) === 1
    assert Stack.get(pid) === []
    assert Stack.pop(pid) === nil
    assert Stack.get(pid) === []
  end
end
