# Create nxn multi array to represent the fabric
# Prase claims
# Add claim id to affected boxes
# If there is already an id in the box, add '#' instead
# Count all '#'s
defmodule Puzzle do

  def overlapping_squares(size, claims) do
    fabric = create_matrix(size)
    claims
     |> Enum.map(&parse_details/1)
     |> mark_fabric(fabric)

  end

  # Marks a fabric using given claim details
  def mark_fabric(claim_map, fabric) do
    fabric
     |> Enum.at(claim_map.coordinate2 + 1)
     |> Enum.at(claim_map.coordinate1 + 1)
     |> IO.inspect

     List.replace_at(fabric, claim_map.coordinate2 + 1, List.replace_at())

    # Enum.map(fabric, fn(inner_list) ->
    #   Enum.map(inner_list, fn(_i) ->  "." end)
    # end)

    # fabric
    # |> Enum.at(claim_map.coordinate2 + 1)
  end

  # Parses a claim and returns data as map
  # Example claim: "#1 @ 1,3: 4x4"
  def parse_details(claim) do
    [id | rest] = String.split(claim, " @ ")
    id = String.slice(id, 1, String.length(id))
    [coord | size] = String.split(Enum.at(rest, 0), ": ")
    [c1 | tail] = String.split(coord, ",")
    [w | rest_size] = String.split(Enum.at(size, 0), "x")

    %{
      id: id,
      coordinate1: String.to_integer(c1),
      coordinate2: String.to_integer(Enum.at(tail, 0)),
      width: String.to_integer(w),
      height: String.to_integer(Enum.at(rest_size, 0))
    }
  end

  # Creates matrix with given size
  # Example: create_matrix(3) will return
  # [
  #  [".", ".", "."]
  #  [".", ".", "."]
  #  [".", ".", "."]
  # ]
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

      test "mark_fabric" do
        fabric =  [
          [".", ".", ".", ".", ".", ".", ".", "."],
          [".", ".", ".", ".", ".", ".", ".", "."],
          [".", ".", ".", ".", ".", ".", ".", "."],
          [".", ".", ".", ".", ".", ".", ".", "."],
          [".", ".", ".", ".", ".", ".", ".", "."],
          [".", ".", ".", ".", ".", ".", ".", "."],
          [".", ".", ".", ".", ".", ".", ".", "."],
          [".", ".", ".", ".", ".", ".", ".", "."]
        ]
        claim_map =  %{
          id: "1",
          coordinate1: 1,
          coordinate2: 3,
          width: 4,
          height: 4
        }
        assert mark_fabric(claim_map, fabric) ==  [
          [".", ".", ".", ".", ".", ".", ".", "."],
          [".", ".", ".", ".", ".", ".", ".", "."],
          [".", ".", ".", ".", ".", ".", ".", "."],
          [".", "1", "1", "1", "1", ".", ".", "."],
          [".", "1", "1", "1", "1", ".", ".", "."],
          [".", "1", "1", "1", "1", ".", ".", "."],
          [".", "1", "1", "1", "1", ".", ".", "."],
          [".", ".", ".", ".", ".", ".", ".", "."]
        ]
      end

      test "create_map" do
        assert create_matrix(2) == [
          [".", "."],
          [".", "."]
        ]
      end

      test "parse_details" do
        assert parse_details("#1 @ 1,3: 4x4") == %{
          id: "1",
          coordinate1: 1,
          coordinate2: 3,
          width: 4,
          height: 4
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
