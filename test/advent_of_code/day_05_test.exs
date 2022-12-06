defmodule AdventOfCode.Day05Test do
  use ExUnit.Case

  import AdventOfCode.Day05

  describe "part1" do
    test "part1" do
      input = """
                      [V]     [C]     [M]
      [V]     [J]     [N]     [H]     [V]
      [R] [F] [N]     [W]     [Z]     [N]
      [H] [R] [D]     [Q] [M] [L]     [B]
      [B] [C] [H] [V] [R] [C] [G]     [R]
      [G] [G] [F] [S] [D] [H] [B] [R] [S]
      [D] [N] [S] [D] [H] [G] [J] [J] [G]
      [W] [J] [L] [J] [S] [P] [F] [S] [L]
       1   2   3   4   5   6   7   8   9

      move 2 from 2 to 7
      move 8 from 5 to 6
      """

      result = part1(input)

      assert result == "ABC"
    end

    test "move moves a number of boxes from one stack to another" do
      stacks_input = [
        ["A", "B", "C"],
        ["D", "E", "F"],
        ["G", "H", "I"]
      ]

      assert move(stacks_input, 0, 1) == [
               ["B", "C"],
               ["A", "D", "E", "F"],
               ["G", "H", "I"]
             ]
    end

    test "moves many boxes" do
      stacks_input = [
        ["A", "B", "C"],
        ["D", "E", "F"],
        ["G", "H", "I"]
      ]

      assert move_many(stacks_input, [%{volume: 2, from: 0, to: 1}]) == [
               ["C"],
               ["A", "B", "D", "E", "F"],
               ["G", "H", "I"]
             ]
    end
  end

  @tag :skip
  test "part2" do
    input = nil
    result = part2(input)

    assert result
  end

  test "box_parser should parse a box" do
    input = "[V]"
    result = box_parser(input)
    assert match?({:ok, ["V"], _, _, _, _}, result)
  end

  describe "stacks_item_parser" do
    test "should parse an empty box" do
      input = "   "
      result = stacks_item_parser(input)
      assert match?({:ok, ["   "], _, _, _, _}, result)
    end

    test "should parse a space with a box" do
      input = "[A]"
      result = stacks_item_parser(input)
      assert match?({:ok, ["A"], _, _, _, _}, result)
    end
  end

  test "alphabetic_line_parser should parse a horizontal line of boxes" do
    input = """
    [V]     [J]     [N]     [H]     [V]
    """

    result = stacks_line_parser(input)

    assert match?(
             {:ok, ["V", "   ", "J", "   ", "N", "   ", "H", "   ", "V"], _, _, _, _},
             result
           )
  end

  test "stacks should take an input string and return a list of stacks" do
    input = """
                    [V]     [C]     [M]
    [V]     [J]     [N]     [H]     [V]
    [R] [F] [N]     [W]     [Z]     [N]
    [H] [R] [D]     [Q] [M] [L]     [B]
    [B] [C] [H] [V] [R] [C] [G]     [R]
    [G] [G] [F] [S] [D] [H] [B] [R] [S]
    [D] [N] [S] [D] [H] [G] [J] [J] [G]
    [W] [J] [L] [J] [S] [P] [F] [S] [L]
     1   2   3   4   5   6   7   8   9

    move 2 from 2 to 7
    move 8 from 5 to 6
    """

    result = parsed_stacks(input)

    assert [
             ["V", "R", "H", "B", "G", "D", "W"],
             ["F", "R", "C", "G", "N", "J"],
             ["J", "N", "D", "H", "F", "S", "L"],
             ["V", "S", "D", "J"],
             ["V", "N", "W", "Q", "R", "D", "H", "S"],
             ["M", "C", "H", "G", "P"],
             ["C", "H", "Z", "L", "G", "B", "J", "F"],
             ["R", "J", "S"],
             ["M", "V", "N", "B", "R", "S", "G", "L"]
           ] == result
  end

  describe "stacks_label_parser" do
    test "should parse a stack label" do
      input = """
       1   2   3   4   5   6   7   8   9
      """

      result = stacks_label_parser(input)
      assert match?({:ok, [1, 2, 3, 4, 5, 6, 7, 8, 9], _, _, _, _}, result)
    end
  end

  describe "stacks_input_parser" do
    test "should parse a stack input" do
      input = """
      [V]     [C]     [M]
      [V]     [J]     [N]     [H]     [V]
       1   2   3   4   5   6   7   8   9
      """

      result = stacks_input_parser(input)

      assert match?(
               {:ok,
                [
                  "V",
                  "   ",
                  "C",
                  "   ",
                  "M",
                  "V",
                  "   ",
                  "J",
                  "   ",
                  "N",
                  "   ",
                  "H",
                  "   ",
                  "V",
                  1,
                  2,
                  3,
                  4,
                  5,
                  6,
                  7,
                  8,
                  9
                ], _, _, _, _},
               result
             )
    end
  end

  describe "moves parser" do
    test "should parse a series of moves" do
      input = """
      move 1 from 2 to 1
      move 3 from 1 to 3
      move 2 from 2 to 1
      move 1 from 1 to 2
      """

      result = moves_parser(input)

      assert match?(
               {:ok,
                [
                  1,
                  2,
                  1,
                  3,
                  1,
                  3,
                  2,
                  2,
                  1,
                  1,
                  1,
                  2
                ], _, _, _, _},
               result
             )
    end

    test "parsed_commands should chunk moves into lists of lists of [number to be moved, start stack for move, and target stack for move" do
      input = """
      move 1 from 2 to 1
      move 3 from 1 to 3
      move 2 from 2 to 1
      move 1 from 1 to 2
      """

      result = parsed_commands(input)

      assert [
               %{to: 1, from: 2, volume: 1},
               %{to: 3, from: 1, volume: 3},
               %{to: 1, from: 2, volume: 2},
               %{to: 2, from: 1, volume: 1}
             ] == result
    end
  end

  describe "stacks_problem_parser" do
    test "parses stacks, stack labels, and moves" do
      input = """
      [V]     [C]     [M]
      [V]     [J]     [N]     [H]     [V]
      [B] [C] [H] [V] [R] [C] [G]     [R]
       1   2   3   4   5   6   7   8   9

      move 1 from 2 to 1
      move 3 from 1 to 3
      move 2 from 2 to 1
      move 1 from 1 to 2
      """

      result = stacks_problem_parser(input)

      assert match?(
               {:ok,
                [
                  "V",
                  "   ",
                  "C",
                  "   ",
                  "M",
                  "V",
                  "   ",
                  "J",
                  "   ",
                  "N",
                  "   ",
                  "H",
                  "   ",
                  "V",
                  "B",
                  "C",
                  "H",
                  "V",
                  "R",
                  "C",
                  "G",
                  "   ",
                  "R",
                  1,
                  2,
                  3,
                  4,
                  5,
                  6,
                  7,
                  8,
                  9,
                  1,
                  2,
                  1,
                  3,
                  1,
                  3,
                  2,
                  2,
                  1,
                  1,
                  1,
                  2
                ], _, _, _, _},
               result
             )
    end
  end

  describe "num_stacks" do
    test "only_label_parser ignores everything except the stack labels" do
      input = """
      [D]
      [N] [C]
      [Z] [M] [P]
       1   2   3

      move 1 from 2 to 1
      move 3 from 1 to 3
      move 2 from 2 to 1
      move 1 from 1 to 2
      """

      result = only_label_parser(input)

      assert match?({:ok, [1, 2, 3], _, _, _, _}, result)
    end

    test "should return the number of stacks" do
      input = """
      [D]
      [N] [C]
      [Z] [M] [P]
       1   2   3

      move 1 from 2 to 1
      move 3 from 1 to 3
      move 2 from 2 to 1
      move 1 from 1 to 2
      """

      result = num_stacks(input)
      assert result == 3
    end
  end
end
