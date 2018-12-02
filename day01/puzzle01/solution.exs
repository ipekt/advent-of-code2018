defmodule Puzzle do

  def find_current_frequency(frequencies) do
    frequencies
    |> Enum.map(fn frequency -> String.to_integer(frequency) end)
    |> Enum.reduce(0, fn freq, acc -> freq + acc end)
    |> IO.inspect()
  end

  def find_current_frequency() do
    get_frequency_changes()
    |> Enum.map(fn frequency -> String.to_integer(frequency) end)
    |> Enum.reduce(0, fn freq, acc -> freq + acc end)
    |> IO.inspect()
  end

  def get_frequency_changes do
    "../input.txt"
    |> Path.expand(__DIR__)
    |> File.read!()
    |> String.trim()
    |> String.split(~r/\n/)
  end
end

# Tests

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
