# Solution from https://www.twitch.tv/videos/344091220
defmodule Puzzle do

  def closest([head | tail]) do
    if closest = Enum.find(tail, &one_char_difference?(&1, head)) do
      common_prefix_and_suffix(head, closest)
    else
      closest(tail)
    end
  end

  def common_prefix_and_suffix(string1, string2) do
    charlist1 = String.to_charlist(string1)
    charlist2 = String.to_charlist(string2)

    charlist1
    |> Enum.zip(charlist2)
    |> Enum.filter(fn {cp1, cp2} -> cp1 == cp2 end)
    |> Enum.map(fn {cp, _} -> cp end)
    |> List.to_string()
  end

  def one_char_difference?(string1, string2) do
    charlist1 = String.to_charlist(string1)
    charlist2 = String.to_charlist(string2)

    charlist1
    |> Enum.zip(charlist2)
    |> Enum.count(fn {cp1, cp2} -> cp1 != cp2 end)
    |> case do
      1 -> true
      _ -> false
    end
  end
end

case System.argv() do

  ["--test"] ->
    ExUnit.start()

    defmodule PuzzleTest do
      use ExUnit.Case

      import Puzzle

      test "find_ids_differ_by_one" do
      assert closest([
        "abcde",
        "fghij",
        "klmno",
        "pqrst",
        "fguij",
        "axcye",
        "wvxyz"]) == "fgij"
      end
    end
  [input_file] ->

    defmodule PuzzleSolution do

    import Puzzle
      input_file
      |> File.read!()
      |> String.split("\n", trim: true)
      |> Puzzle.closest()
      |> IO.puts
    end
end
