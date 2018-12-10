# Solution from https://www.twitch.tv/videos/346879012?collection=YDM6eKu6bhV1Nw
defmodule Puzzle do

  # Parse the input
  # Example: "#1 @ 100,366: 24x27" => [1, 100, 366, 24, 27]
  def parse_claim(string) when is_binary(string) do
      string
      |> String.split(["#", " @ ", ",", ": ", "x"], trim: true)
      |> Enum.map(&String.to_integer/1)
  end

  @doc"""
  Retrieves all claimed inches.

  ## Examples
  iex> claimed = Puzzle.claimed_inches([
    "#1 @ 1,3: 4x4",
    "#2 @ 3,1: 4x4",
    "#3 @ 5,5: 2x2"
  ])
  iex> claimed[{4, 2}]
  [2]
  iex> claimed[{4, 4}]
  [2, 1]
  """
  def claimed_inches(claims) do
    Enum.reduce(claims, %{}, fn (claim, acc) ->
      [id, left, top, width, height] = parse_claim(claim)

      Enum.reduce((left + 1)..(left + width), acc, fn x, acc ->
        Enum.reduce((top + 1)..(top + height), acc, fn y, acc ->
          Map.update(acc, {x, y}, [id], &[id | &1])
        end)
      end)
    end)
  end

  @doc """
  Retrieves overlapped inches.

  ## Examples
  iex>  claimed = Puzzle.overlapped_inches([
    "#1 @ 1,3: 4x4",
    "#2 @ 3,1: 4x4",
    "#3 @ 5,5: 2x2"
  ]) |> Enum.sort()
  [{4,4}, {4,5}, {5,4}, {5,5}]
  """
  def overlapped_inches(claims) do
    for {coordinate, [_, _ | _]} <- claimed_inches(claims) do
      coordinate
    end
  end
end

case System.argv() do
  ["--test"] ->
    ExUnit.start()

    defmodule PuzzleTest do
      use ExUnit.Case

      import Puzzle

      test "parse_claim" do
        assert parse_claim("#1 @ 100,366: 24x27") === [1, 100, 366, 24, 27]
      end

      test "claimed_inches" do
        assert claimed_inches([
          "#1 @ 1,3: 4x4",
          "#2 @ 3,1: 4x4",
          "#3 @ 5,5: 2x2"
        ]) === [2]
      end
    end

  [input_file] ->
    defmodule PuzzleSolution do

      import Puzzle
        input_file
        |> File.read!()
        |> String.split("\n", trim: true)
        |> Puzzle.overlapped_inches()
        |> length
        |> IO.puts
  end
end
