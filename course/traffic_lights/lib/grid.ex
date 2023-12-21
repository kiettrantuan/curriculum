defmodule TrafficLights.Grid do
  @moduledoc """
  Documentation for `TrafficLights.Grid`.
  """

  @doc """
  Hello world.
  """
  use GenServer

  def start_link(opts \\ []) do
    pid_list =
      Enum.map(1..5, fn _ ->
        {:ok, pid} = TrafficLights.Light.start_link()
        pid
      end)

    GenServer.start_link(__MODULE__, {pid_list, pid_list}, opts)
  end

  def transition(pid) do
    GenServer.cast(pid, :transition)
  end

  def current_lights(pid) do
    GenServer.call(pid, :current_lights)
  end

  def init(init_arg) do
    {:ok, init_arg}
  end

  def handle_cast(:transition, {pid_list, update_order}) do
    [pid | rest] = update_order
    TrafficLights.Light.transition(pid)
    {:noreply, {pid_list, rest ++ [pid]}}
  end

  def handle_call(:current_lights, _from, {pid_list, update_order}) do
    current_light_list = Enum.map(pid_list, fn pid -> TrafficLights.Light.current_light(pid) end)

    {:reply, current_light_list, {pid_list, update_order}}
  end
end
