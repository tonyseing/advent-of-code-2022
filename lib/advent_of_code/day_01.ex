defmodule AdventOfCode.Day01 do

  def part1(args) do
    args
      |> parse_food_list
      |> Enum.map(fn calories_list_for_elf -> Enum.sum(calories_list_for_elf) end)
      |> Enum.max
  end

  def part2(args) do
    args
      |> parse_food_list
      |> Enum.map(fn calories_list_for_elf -> Enum.sum(calories_list_for_elf) end)
      |> Enum.sort
      |> Enum.take(-3)
      |> Enum.sum
  end

  @spec parse_food_list(binary) :: [binary]
  @doc """
  Parses a string into a list of lists of integers.

  ## Examples

      iex> AdventOfCode.Day01.parse("1
      2
      3

      4
      5")
      [[1, 2, 3], [4, 5]]
  """
  def parse_food_list(food_list) do
    String.split(food_list, "\n\n")
    |> Enum.map(fn elf_list -> String.split(elf_list, "\n") end)
    |> Enum.map(fn elf_list -> Enum.filter(elf_list, fn calorie_string -> calorie_string != "" end) end)
    |> Enum.map(fn elf_list -> Enum.map(elf_list, fn calorie_string -> String.to_integer(calorie_string) end) end)
  end
end
