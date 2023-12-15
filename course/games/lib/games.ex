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

  def main(_args \\ nil) do
    IO.gets("""

    What game would you like to play?
    1. Guessing Game
    2. Rock Paper Scissors
    3. Wordle

    enter "stop" to exit

    """)
    |> case do
      "1\n" -> Games.Guessing.play()
      "2\n" -> Games.RockPaperScissors.play()
      "3\n" -> Games.Wordle.play()
      "stop\n" -> nil
      _ -> IO.puts("Not existed!\n")
    end
  end
end
