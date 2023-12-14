defmodule Games do
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
