defmodule Games do
  @moduledoc """
  Documentation for `Games`
  """

  @doc """
  get game id that user want to play

  ## Examples
      iex> Games.test_doc(1, 1)
      2
  """
  @spec test_doc(integer, integer) :: integer()
  def test_doc(int, int) do
    int + int
  end

  def play do
    IO.gets("""
    Enter the game id you want to play:

    1. Guessing
    2. Rock Paper Scissors

    """)
    |> case do
      "1\n" -> Games.GuessingGame.play()
      "2\n" -> Games.RockPaperScissorsGame.play()
      _ -> IO.puts("Not existed!")
    end
  end
end