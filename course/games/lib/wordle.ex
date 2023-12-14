defmodule Games.Wordle do
  def retry(answer, attempts \\ 0) do
    guess =
      IO.gets("\nEnter a five letter word: ")
      |> String.trim()

    ((feedback(answer, guess)
      |> Enum.reduce("[", fn color, acc ->
        acc <>
          case color do
            :green -> IO.ANSI.green() <> ":green"
            :yellow -> IO.ANSI.yellow() <> ":yellow"
            :grey -> IO.ANSI.light_black() <> ":grey"
          end <> IO.ANSI.reset() <> ", "
      end)
      |> String.trim_trailing(", ")) <> "]")
    |> IO.puts()

    cond do
      guess === answer ->
        IO.puts("You win!\n")

      attempts === 5 ->
        IO.puts("You lose! the answer was #{answer}\n")

      true ->
        retry(answer, attempts + 1)
    end
  end

  def feedback(answer, guess) do
    answer_list = String.split(answer, "", trim: true)
    guess_list = String.split(guess, "", trim: true)
    range = 0..(String.length(answer) - 1)

    green_with_remain =
      Enum.reduce(range, %{remain: %{}, res: []}, fn idx, acc ->
        current_answer = Enum.at(answer_list, idx)
        current_guess = Enum.at(guess_list, idx)

        if current_guess === current_answer do
          %{acc | res: acc.res ++ [:green]}
        else
          updated =
            Map.update(acc.remain, current_answer, [idx], fn prev ->
              prev ++ [idx]
            end)

          %{%{acc | remain: updated} | res: acc.res ++ [current_guess]}
        end
      end)

    Enum.reduce(green_with_remain.res, %{green_with_remain | res: []}, fn guess_or_green, acc ->
      remain_list = Map.get(acc.remain, guess_or_green)

      cond do
        guess_or_green === :green ->
          %{acc | res: acc.res ++ [:green]}

        remain_list !== nil and remain_list !== [] ->
          updated =
            Map.update!(acc.remain, guess_or_green, fn prev ->
              List.delete_at(prev, 0)
            end)

          %{%{acc | remain: updated} | res: acc.res ++ [:yellow]}

        true ->
          %{acc | res: acc.res ++ [:grey]}
      end
    end).res
  end

  def play do
    IO.puts("Guess a word")
    retry(Enum.random(["toast", "tarts", "hello", "beats"]))
  end
end
