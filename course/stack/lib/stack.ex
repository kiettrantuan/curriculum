defmodule Stack do
  @moduledoc """
  Documentation for `Stack`.
  """

  @doc """
  Hello world.
  """
  use GenServer

  def start_link(opts \\ []) do
    initial_state = Keyword.get(opts, :initial_state, [])
    GenServer.start_link(__MODULE__, initial_state, opts)
  end

  def push(pid, element) do
    GenServer.cast(pid, {:push, element})
  end

  def pop(pid) do
    GenServer.call(pid, :pop)
  end

  def get(pid) do
    GenServer.call(pid, :get)
  end

  @spec init(any()) :: {:ok, any()}
  def init(init_arg) do
    {:ok, init_arg}
  end

  def handle_cast({:push, element}, state) do
    {:noreply, [element] ++ state}
  end

  def handle_call(:pop, _from, state) do
    case state do
      [latest | remain] -> {:reply, latest, remain}
      _ -> {:reply, nil, []}
    end
  end

  def handle_call(:get, _from, state) do
    {:reply, state, state}
  end
end
