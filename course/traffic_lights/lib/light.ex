defmodule TrafficLights.Light do
  @moduledoc """
  Documentation for `TrafficLights.Light`.
  """

  @doc """
  Hello world.
  """
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :green, opts)
  end

  def transition(pid) do
    GenServer.cast(pid, :transition)
  end

  def current_light(pid) do
    GenServer.call(pid, :current_light)
  end

  def init(init_arg) do
    {:ok, init_arg}
  end

  def handle_cast(:transition, state) do
    case state do
      :green -> {:noreply, :yellow}
      :yellow -> {:noreply, :red}
      :red -> {:noreply, :green}
    end
  end

  def handle_call(:current_light, _from, state) do
    {:reply, state, state}
  end
end
