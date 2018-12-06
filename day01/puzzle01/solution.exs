defmodule Puzzle do

  def find_current_frequency(frequencies) do
    frequencies
    |> Enum.map(fn frequency -> String.to_integer(frequency) end)
    |> Enum.sum()
  end

  def find_current_frequency() do
    get_frequency_changes()
    |> Enum.map(fn frequency -> String.to_integer(frequency) end)
    |> Enum.sum()
  end

  def get_frequency_changes do
    "../input.txt"
    |> Path.expand(__DIR__)
    |> File.read!()
    |> String.split(~r/\n/, trim: true)
  end

  # Alternative solution from https://www.twitch.tv/videos/343661380 that is a lot faster.
  def find_current_frequency_alt() do
    "../input.txt"
    |> File.stream!([], :line)
    |> Stream.map(fn line ->
      {integer, _leftover} = Integer.parse(line)
       integer
      end)
    |> Enum.sum()
  end
end

# Runners

case System.argv() do
  ["--test"] ->
  ExUnit.start()

  defmodule PuzzleTest do
    use ExUnit.Case

    import Puzzle

    test "numbers are summed correctly" do
      assert find_current_frequency(["+1", "+2", "+3"]) == 6
    end

    test "numbers are reduced correctly" do
      assert find_current_frequency(["-1", "-1", "-10"]) == -12
    end

    test "numbers are calculated correctly" do
      assert find_current_frequency(["+200", "-10", "+3"]) == 193
    end
  end

  ["--alt"] ->
  defmodule PuzzleSolutionAlt do
    import Puzzle

    find_current_frequency_alt()
    |> IO.inspect()
  end

  _ ->
  defmodule PuzzleSolution do
    import Puzzle

    find_current_frequency()
    |> IO.inspect()
  end
end
