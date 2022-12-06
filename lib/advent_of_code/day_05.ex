defmodule AdventOfCode.Day05 do
  import Structure
  import NimbleParsec

  @empty_box "   "

  alphabetic_char_parser = ascii_string([?a..?z, ?A..?Z], 1)

  box_parser =
    ignore(string("[")) |> concat(alphabetic_char_parser) |> concat(ignore(string("]")))

  stacks_item_parser = choice([string(@empty_box), box_parser])
  stacks_spacer = string(" ")

  stacks_line_parser =
    stacks_item_parser
    |> concat(choice([ignore(stacks_spacer), ignore(string("\n"))]))
    |> times(9)

  stack_label_parser =
    ignore(string(" "))
    |> concat(integer(min: 1))
    |> concat(optional(choice([ignore(string(" ")), ignore(string("\n"))])))
    |> concat(optional(choice([ignore(string(" ")), ignore(string("\n"))])))
    |> times(min: 1)

  only_label_parser = eventually(stack_label_parser)

  moves_parser =
    ignore(string("move"))
    |> concat(ignore(string(" ")))
    |> concat(integer(min: 1))
    |> concat(ignore(string(" from ")))
    |> concat(integer(min: 1))
    |> concat(ignore(string(" to ")))
    |> concat(integer(min: 1))
    |> concat(ignore(string("\n")))
    |> times(min: 1)
    |> eventually()

  stacks_lines_parser = stacks_line_parser |> times(min: 1) |> eventually
  stacks_input_parser = stacks_lines_parser |> concat(stack_label_parser)

  stacks_problem_parser =
    stacks_input_parser
    |> concat(moves_parser)

  defparsec(:box_parser, box_parser)
  defparsec(:stacks_item_parser, stacks_item_parser)
  defparsec(:stacks_line_parser, stacks_line_parser)
  defparsec(:stacks_lines_parser, stacks_lines_parser)
  defparsec(:stacks_label_parser, stack_label_parser)
  defparsec(:stacks_input_parser, stacks_input_parser)
  defparsec(:moves_parser, moves_parser)
  defparsec(:stacks_problem_parser, stacks_problem_parser)
  defparsec(:only_label_parser, only_label_parser)

  def num_stacks(input) do
    input
    |> only_label_parser()
    |> case do
      {:ok, label_list, _, _, _, _} -> Enum.count(label_list)
      _ -> 0
    end
  end

  def push(stack, item) do
    [item | stack]
  end

  def pop(stack) do
    [item | rest] = stack
    {item, rest}
  end

  def transpose(rows) do
    rows
    |> List.zip()
    |> Enum.map(&Tuple.to_list/1)
  end

  def move(stacks, from, to) do
    {item, from_stack} = pop(Enum.at(stacks, from))
    to_stack = push(Enum.at(stacks, to), item)
    stacks |> List.replace_at(from, from_stack) |> List.replace_at(to, to_stack)
  end

  def move_many(stacks, moves) do
    Enum.reduce(moves, stacks, fn {from, to}, stacks -> move(stacks, from, to) end)
  end

  def parsed_stacks(input) do
    stacks_length = num_stacks(input) |> IO.inspect(label: 'stacks_length')

    input
    |> stacks_lines_parser()
    |> case do
      {:ok, stacks, _, _, _, _} ->
        stacks
        |> Enum.chunk_every(stacks_length)
        |> transpose
        |> Enum.map(fn stack ->
          Enum.reject(stack, fn item ->
            item == @empty_box
          end)
        end)

      _ ->
        {[], [], []}
    end
  end

  def parsed_commands(input) do
    input
    |> moves_parser
    |> case do
      {:ok, commands, _, _, _, _} ->
        Enum.chunk_every(commands, 3)
        |> Enum.map(fn [a, b, c] -> %{volume: a, from: b - 1, to: c - 1} end)

      _ ->
        []
    end
  end

  def part1(input) do
    commands = parsed_commands(input)
    stacks = parsed_stacks(input)
    move_many(stacks, commands)
  end

  def part2(input) do
  end
end
