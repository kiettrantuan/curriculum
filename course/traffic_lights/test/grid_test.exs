defmodule GridTest do
  use ExUnit.Case
  doctest TrafficLights.Grid

  test "transition" do
    {:ok, pid} = TrafficLights.Grid.start_link([])

    assert [:green, :green, :green, :green, :green] == TrafficLights.Grid.current_lights(pid)

    TrafficLights.Grid.transition(pid)

    assert [:yellow, :green, :green, :green, :green] == TrafficLights.Grid.current_lights(pid)

    TrafficLights.Grid.transition(pid)
    TrafficLights.Grid.transition(pid)
    TrafficLights.Grid.transition(pid)
    TrafficLights.Grid.transition(pid)
    TrafficLights.Grid.transition(pid)

    [:red, :yellow, :yellow, :yellow, :yellow] = TrafficLights.Grid.current_lights(pid)

    TrafficLights.Grid.transition(pid)
    TrafficLights.Grid.transition(pid)
    TrafficLights.Grid.transition(pid)
    TrafficLights.Grid.transition(pid)
    TrafficLights.Grid.transition(pid)

    [:green, :red, :red, :red, :red] = TrafficLights.Grid.current_lights(pid)
  end
end
