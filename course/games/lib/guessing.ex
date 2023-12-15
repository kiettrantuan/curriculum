defmodule Games.Guessing do
  @moduledoc """
  Documentation for `Games.Guessing`
  """
  def retry(answer, attempts \\ 0) do
    guess =
      IO.gets("Enter your guess: ")
      |> String.replace(~r/\D/, "")
      |> String.to_integer()

    cond do
      guess === answer ->
        IO.puts("You win!")

      attempts === 5 ->
        IO.puts("You lose! the answer was #{answer}")

      guess < answer ->
        IO.puts("Too Low!")
        retry(answer, attempts + 1)

      guess > answer ->
        IO.puts("Too High!")
        retry(answer, attempts + 1)
    end
  end

  def play do
    IO.puts("Guess a number between 1 and 10\n")
    retry(Enum.random(1..10))
  end
end
