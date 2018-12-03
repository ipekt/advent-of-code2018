defmodule Puzzle do
  # If frequences are not integer convert it
  # Scan the list, passing the total
  # Filter scanned list to find the first duplicate value
  # If not found, scan the list again but use the last value from previously scanned list as accumulator

  def process(frequencies, prevAggregated, accumalated) do
    {original, agg} = aggregate(frequencies, accumalated)

    {original, prevAggregated ++ agg}
     |> find_duplicated
  end

  def process(frequencies) do
    frequencies
     |> convert
     |> aggregate(0)
     |> find_duplicated
  end

  def process() do
    get_frequency_changes()
     |> convert
     |> aggregate(0)
     |> find_duplicated
  end

  def find_duplicated({originals, aggregatedOnes}) do
    IO.inspect(aggregatedOnes)
    duplicatedOnes = Enum.filter(aggregatedOnes, fn f -> Enum.count(aggregatedOnes, fn acc -> acc == f end) > 1 end)

    if (duplicatedOnes == []) do
      process(originals, aggregatedOnes, Enum.at(aggregatedOnes, Enum.count(aggregatedOnes) - 1))
    else
      IO.inspect(Enum.at(duplicatedOnes, 0))
      Enum.at(duplicatedOnes, 0)
    end
  end

  def aggregate(frequencies, acc), do: {frequencies, testF(frequencies, acc)}

  def testF(frequencies, 0) do
    [head | tail] = Enum.scan(frequencies, &(&1 + &2))
    tail
  end

  def testF(frequencies, acc) do
    Enum.scan(frequencies, acc, &(&1 + &2))
  end

  def convert(frequencies) do
    frequencies
    |> Enum.map(fn frequency -> String.to_integer(frequency) end)
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

  # test "test case 1" do
  #   assert process(["+1", "-1"]) == 0
  # end

  # test "test case 2" do
  #   assert process(["+1", "-2", "+3", "+1", "+1", "-2"]) == 2
  # end

  # test "test case 3" do
  #     # 3 6 10 8 4 -> 7 10 14 12 8
  #   assert process(["+3", "+3", "+4", "-2", "-4"]) == 10
  # end

  # test "test case 4" do
  #   assert process(["-6", "+3", "+8", "+5", "-6"]) == 5
  # end

  # test "test case 5" do
  #   # 14 12 5 1 -> 8 15 13 6 2 -> 9 16 14 7 3
  #   assert process(["+7", "+7", "-2", "-7", "-4"]) == 14
  # end

  test "find solution" do
    assert process() == 2
  end
end

