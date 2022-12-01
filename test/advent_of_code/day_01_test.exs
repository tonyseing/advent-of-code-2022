defmodule AdventOfCode.Day01Test do
  use ExUnit.Case

  import AdventOfCode.Day01

  test "parse_food_list parses a string with newlines into a list of list of calories" do
    assert parse_food_list(
"""
1
2
3

40
50
"""
) == [[1, 2, 3], [40, 50]]
  end

  test "elf_food_calories_max returns the total calories carried by the elf with the most total calories" do
    food_list =
    """
    1
    2
    3

    40
    50

    0
    """
    result = part1(food_list)

    assert result == 90
  end

  test "part2" do
    food_list =
      """
      1
      2
      3

      40
      50

      11
      22
      33

      5

      0
      """
      result = part2(food_list)

      assert result == 162
  end
end
