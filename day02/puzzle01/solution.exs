defmodule Puzzle do
  # Go over each box ids
  # Count the number that have an ID containing  exactly two of any letter
  # and then separately counting those with exactly three of any letter.
  # Multiply the totals
  def repeated_letters_checksum(file_stream) do
    {doubles, triples} = file_stream
      |> Enum.reduce({0, 0}, fn next_id, {total_doubles, total_triples} ->
        {doubles, triples} = next_id
          |> count_characters
          |> get_doubles_and_triples

          {doubles + total_doubles, triples + total_triples}
      end)

    doubles * triples
  end

  def get_doubles_and_triples(values) do
    doubles = Enum.count(values, fn {_codepoint, count} -> count == 2 end)
    triples = Enum.count(values, fn {_codepoint, count} -> count == 3 end)

    {min(doubles, 1), min(triples, 1)}
  end

  def count_characters(text) do
    text
      |> String.to_charlist()
      |> Enum.reduce(%{}, fn (codepoint, acc) ->
        Map.update(acc, codepoint, 1, &(&1 + 1))
      end)
  end
end

case System.argv() do
  ["--test"] ->
    ExUnit.start()

    defmodule PuzzleTest do
      use ExUnit.Case

      import Puzzle

      test "count_doubles" do
        assert count_characters("aabbcccd") == %{
          ?a => 2,
          ?b => 2,
          ?c => 3,
          ?d => 1
        }
      end

      test "repeated_letters_checksum" do
      assert repeated_letters_checksum([
        "abcdef\n",
        "bababc\n",
        "abbcde\n",
        "abcccd\n",
        "aabcdd\n",
        "abcdee\n",
        "ababab\n"]) == 4*3
      end
    end
  [input_file] ->

    defmodule PuzzleSolution do

    import Puzzle
      input_file
      |> File.stream!([], :line)
      |> Puzzle.repeated_letters_checksum()
      |> IO.puts
    end
end
