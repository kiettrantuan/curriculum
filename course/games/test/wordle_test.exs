defmodule WordleTest do
  use ExUnit.Case
  doctest Games.Wordle

  describe "feedback/2" do
    test "All Green" do
      assert Games.Wordle.feedback("ABCDE", "ABCDE") == [:green, :green, :green, :green, :green]
    end

    test "All Yellow" do
      assert Games.Wordle.feedback("ABCDE", "EDBCA") == [
               :yellow,
               :yellow,
               :yellow,
               :yellow,
               :yellow
             ]
    end

    test "All Gray" do
      assert Games.Wordle.feedback("ABCDE", "HIJKL") == [:grey, :grey, :grey, :grey, :grey]
    end

    test "Edge Case" do
      assert Games.Wordle.feedback("XXXAA", "AAAAY") == [:yellow, :grey, :grey, :green, :grey]
    end
  end
end
