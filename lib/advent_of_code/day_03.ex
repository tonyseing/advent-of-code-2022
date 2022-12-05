defmodule AdventOfCode.Day03 do

  import NimbleParsec

  string_char_parser = ascii_string([?a..?z, ?A..?Z], min: 1)
  lines_parser = string_char_parser |> ignore(string("\n")) |> times(min: 1)

  defparsec(:lines_parser, lines_parser)

  def part1(input) do
    {:ok, rucksacks} = parse_rucksacks(input)
    Enum.map(rucksacks, fn rucksack ->
     {compartment_1, compartment_2} = rucksack
     common_letters = compartment_1
        |> String.graphemes()
        |> Enum.filter(fn letter -> compartment_2 |> String.contains?(letter) end)
        |> Enum.uniq()
      case common_letters do
        [] -> 0
        _ -> Enum.at(common_letters, 0) |> priority_score()
      end
    end) |> Enum.sum()
  end

  def part2(input) do
    {:ok, group_rucksacks} = parse_groups(input)
    Enum.map(group_rucksacks, fn group_rucksack ->
        [ruck_1, ruck_2, ruck_3] = group_rucksack
        common_letters = ruck_1
          |> String.graphemes()
          |> Enum.filter(fn letter ->
               String.contains?(ruck_2, letter) and
               String.contains?(ruck_3, letter)
             end)
          |> Enum.uniq()
        case common_letters do
          [] -> 0
          _ -> Enum.at(common_letters, 0) |> priority_score()
        end
      end) |> Enum.sum()
  end

  # need to refactor this. There's probably a mapping I can do if I know the ASCII values for a and A.
  def priority_score(char) do
    case char do
      "a" -> 1
      "b" -> 2
      "c" -> 3
      "d" -> 4
      "e" -> 5
      "f" -> 6
      "g" -> 7
      "h" -> 8
      "i" -> 9
      "j" -> 10
      "k" -> 11
      "l" -> 12
      "m" -> 13
      "n" -> 14
      "o" -> 15
      "p" -> 16
      "q" -> 17
      "r" -> 18
      "s" -> 19
      "t" -> 20
      "u" -> 21
      "v" -> 22
      "w" -> 23
      "x" -> 24
      "y" -> 25
      "z" -> 26
      "A" -> 27
      "B" -> 28
      "C" -> 29
      "D" -> 30
      "E" -> 31
      "F" -> 32
      "G" -> 33
      "H" -> 34
      "I" -> 35
      "J" -> 36
      "K" -> 37
      "L" -> 38
      "M" -> 39
      "N" -> 40
      "O" -> 41
      "P" -> 42
      "Q" -> 43
      "R" -> 44
      "S" -> 45
      "T" -> 46
      "U" -> 47
      "V" -> 48
      "W" -> 49
      "X" -> 50
      "Y" -> 51
      "Z" -> 52
    end
  end

  def parse_rucksacks(input) do
    {:ok, lines, _, _, _, _} = lines_parser(input)
    parsed_rucksacks = Enum.map(lines,
      fn line ->
        rucksack_length = String.length(line)
        compartment_length = div(rucksack_length, 2)
        first_half = String.slice(line, 0, compartment_length)
        second_half = String.slice(line, compartment_length, rucksack_length)
        {first_half, second_half}
      end)
    {:ok, parsed_rucksacks}
  end

  def parse_groups(input) do
    {:ok, lines, _, _, _, _} = lines_parser(input)
    groups = Enum.chunk_every(lines, 3)
    {:ok, groups}
  end
end
