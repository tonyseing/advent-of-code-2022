defmodule AdventOfCode.Day04 do
  import NimbleParsec

  range_separator_parser = string("-")
  range_parser =
    integer(min: 1)
    |> concat(ignore(range_separator_parser))
    |> concat(integer(min: 1))
  line_separator_parser = string("\n")
  range_couple_separator_parser = string(",")
  tuple_range_parser =
    range_parser
    |> concat(ignore(range_couple_separator_parser))
    |> concat(range_parser)
  assignments_parser =
    tuple_range_parser
    |> concat(ignore(line_separator_parser))
    |> times(min: 1)

  #lines_parser = string_char_parser |> ignore(string("-")) |> times(min: 1)

  defparsec(:range_parser, range_parser)
  defparsec(:tuple_range_parser, tuple_range_parser)
  defparsec(:assignments_parser_helper, assignments_parser)

  def parse_assignments(input) do
    case assignments_parser_helper(input) do
      {:ok, assignments, _, _, _, _} ->
        {:ok, Enum.chunk_every(assignments, 2)
              |> Enum.chunk_every(2)}
      _ -> {:error, []}
    end
  end

  def part1(input) do
    input
    |> parse_assignments
    |> case do
      {:ok, assignments} ->
        assignments
        |> Enum.count(fn ([range_1, range_2]) ->
          Enum.at(range_1, 0) <= Enum.at(range_2, 0) and Enum.at(range_1, 1) >= Enum.at(range_2, 1) or
          Enum.at(range_1, 0) >= Enum.at(range_2, 0) and Enum.at(range_1, 1) <= Enum.at(range_2, 1)
        end)
      _ -> 0
    end
  end

  def part2(_args) do
  end

end
