# Create nxn multi array to represent the fabric
# Add claim id to affected boxes
# If there is already an id in the box, add '#' instead
# Count all '#'s
defmodule Puzzle do

  def overlapping_squares(size, claims) do
    fabric = create_matrix(size)
    claims
    #  |> process_details(claims)
    #  |> mark_fabric(fabric)

  end

  # claim: "#1 @ 1,3: 4x4"
  def process_details(claim) do
    [id | rest] = String.split(claim, " @ ")
    id = String.slice(id, 1, String.length(id))
    [coord | size] = String.split(Enum.at(rest, 0), ": ")
    [c1 | tail] = String.split(coord, ",")
    IO.inspect(tail)
    [w | rest_size] = String.split(Enum.at(size, 0), "x")

    # make a map
    {id, c1, Enum.at(tail, 0), w, Enum.at(rest_size, 0)}
  end

  def create_matrix(size) do
    Enum.map(0..size-1, fn(_i) ->
      Enum.map(0..size-1, fn(_i) ->  "." end)
    end)
  end

end

case System.argv() do
  ["--test"] ->
    ExUnit.start()

    defmodule PuzzleTest do
      use ExUnit.Case

      import Puzzle

      test "create_map" do
        assert create_matrix(2) == [
          [".", "."],
          [".", "."]
        ]
      end

      test "process_details" do
        assert process_details("#1 @ 1,3: 4x4") == {
          "1",
          "1",
          "3",
          "4",
          "4"
        }
      end

      # test "overlapping_squares" do
      #   assert overlapping_squares(8, [
      #     "#1 @ 1,3: 4x4",
      #     "#2 @ 3,1: 4x4",
      #     "#3 @ 5,5: 2x2"
      #   ]) == 4
      # end
    end
  [input_file] ->

    defmodule PuzzleSolution do

    import Puzzle
      input_file
      |> File.stream!([], :line)
      |> Puzzle.overlapping_squares()
      |> IO.puts
    end
end
