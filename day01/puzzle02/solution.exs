defmodule Puzzle do
  # If frequences are not integer convert it
  # Scan the list, passing the total
  # Filter scanned list to find the first duplicate value
  # If not found, scan the list again but use the last value from previously scanned list as accumulator
  defstruct frequencies: ["+1", "-2"]

  def find_looped_frequency(frequencies) do
    frequencies
      |> Enum.map(fn frequency -> String.to_integer(frequency) end)
      |> Enum.scan(fn f, acc -> f + acc end)
      |> find_duplicated()
  end

  def find_looped_frequency2(accumulator) do
    # Map.get(%Puzzle{}, :frequencies)
    #   |> Enum.scan(fn f, accumulator -> f + accumulator end)
    #   |> IO.inspect
    #   |> find_duplicated()
  end

  def find_looped_frequency() do
    get_frequency_changes()
    |> Enum.map(fn frequency -> String.to_integer(frequency) end)
    |> Enum.scan(fn f, acc -> f + acc end)
    |> find_duplicated()
  end

  def find_duplicated(frequencies) do
    duplicatedList = Enum.filter(frequencies, fn f -> Enum.count(frequencies, fn acc -> acc == f end) > 1 end)
    IO.inspect(Enum.at(frequencies, Enum.count(frequencies) - 1))

    if (duplicatedList == []) do
      # get last item and call method  againa
      find_looped_frequency2(Enum.at(frequencies, Enum.count(frequencies) - 1))
    else
      Enum.at(duplicatedList, 0)
    end
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
  #   assert find_looped_frequency(["+1", "-1"]) == 0
  # end

  # test "test case 2" do
  #   assert find_looped_frequency(["+1", "-2", "+3", "+1", "+1", "-2"]) == 2
  # end

  test "test case 3" do
    assert find_looped_frequency(["+3", "+3", "+4", "-2", "-4"]) == 10
  end
  # 3 6 10 8 4 -> 7 10 14 12 8

  # test "test case 4" do
  #   assert find_looped_frequency(["-6", "+3", "+8", "+5", "-6"]) == 5
  # end

  # test "test case 5" do
  #   assert find_looped_frequency(["+7", "+7", "-2", "-7", "-4"]) == 14
  # end

  # test "find solution" do
  #   assert find_looped_frequency() == 2
  # end
end

