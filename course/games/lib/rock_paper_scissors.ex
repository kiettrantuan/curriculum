defmodule Games.RockPaperScissors do
  @moduledoc """
  Documentation for `Games.RockPaperScissors`
  """

  @doc """
  whether player 1 win or not

  ## Examples
      iex> Games.RockPaperScissors.p1_win("rock", "scissors")
      true

      iex> Games.RockPaperScissors.p1_win("scissors", "rock")
      false

      iex> Games.RockPaperScissors.p1_win("paper", "paper")
      false
  """
  @spec p1_win(String.t(), String.t()) :: boolean()
  def p1_win(p1, p2) do
    {p1, p2} in [{"rock", "scissors"}, {"scissors", "paper"}, {"paper", "rock"}]
  end

  def retry do
    choices = ["rock", "paper", "scissors"]

    ai = Enum.random(choices)

    input = IO.gets("Choose rock, paper, or scissors: ")

    [user | _] = Regex.run(~r/rock|paper|scissors/, input) || [""]

    if user in choices === false do
      IO.puts("Invalid choice!\n")
    else
      cond do
        user === ai -> IO.puts("It's a tie!\n")
        p1_win(user, ai) === true -> IO.puts("You win! #{user} beats #{ai}.\n")
        true -> IO.puts("You close! #{ai} beats #{user}.\n")
      end

      retry()
    end
  end

  def play do
    IO.puts("Rock, Paper, or Scissors\n")
    retry()
  end
end
