defmodule LightTest do
  use ExUnit.Case
  doctest TrafficLights.Light

  test "transition" do
    {:ok, pid} = TrafficLights.Light.start_link([])

    assert :green == TrafficLights.Light.current_light(pid)
    TrafficLights.Light.transition(pid)

    assert :yellow == TrafficLights.Light.current_light(pid)
    TrafficLights.Light.transition(pid)

    assert :red == TrafficLights.Light.current_light(pid)
    TrafficLights.Light.transition(pid)

    assert :green = TrafficLights.Light.current_light(pid)
  end
end
