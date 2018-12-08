# Solution from  https://www.twitch.tv/videos/343661380
defmodule Puzzle do
  def repeated_frequency(file_stream) do
    file_stream
    |> Stream.map(fn line ->
      {integer, _leftover} = Integer.parse(line)
      integer
    end)
    |> Stream.cycle()
    |> Enum.reduce_while({0, []}, fn x, {current_frequency, seen_frequencies} ->
      new_frequency = current_frequency + x

      if new_frequency in seen_frequencies do
        {:halt, new_frequency}
      else
      {:cont, {new_frequency, [new_frequency | seen_frequencies]}}
      end
    end)
  end
end

case System.argv() do
  ["--test"] ->
    ExUnit.start()

    defmodule PuzzleTest do
      use ExUnit.Case

      import Puzzle

      test "final_frequency" do
      assert repeated_frequency([
        "+1\n",
        "-2\n",
        "+3\n",
        "+1\n"]) == 2
      end
    end
  [input_file] ->

    defmodule PuzzleSolution do

    import Puzzle
      input_file
      |> File.stream!([], :line)
      |> Puzzle.repeated_frequency()
      |> IO.puts
    end
end
