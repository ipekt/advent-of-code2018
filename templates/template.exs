# This is script template for puzzle solutions.
# Usage:
# Run tests `elixir filename.exs --test`
# Pass input file path to use in the puzzle `elixir filename.exs "../input.exs"`
defmodule Puzzle do

  def test() do
    true
  end

end

case System.argv() do
  ["--test"] ->
    ExUnit.start()

    defmodule PuzzleTest do
      use ExUnit.Case

      import Puzzle

      test "test" do
        assert test() == true
      end

  [input_file] ->
    defmodule PuzzleSolution do

      import Puzzle
        input_file
        |> File.stream!([], :line)
        |> Puzzle.test()
        |> IO.puts
  end
end
