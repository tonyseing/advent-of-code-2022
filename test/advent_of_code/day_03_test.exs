defmodule AdventOfCode.Day03Test do
  use ExUnit.Case

  import AdventOfCode.Day03

  test "part1" do
    input =
      """
      vJrwpWtwJWrh
      vJrwpBawJTrB
      """
    result = part1(input)

    assert result == 72
  end

  @tag :skip
  test "part2" do
    input = nil
    result = part2(input)

    assert result
  end

  test "priority_score" do
    assert priority_score("a") == 1
    assert priority_score("A") == 27
    assert priority_score("z") == 26
    assert priority_score("Z") == 52
  end

  test "AdventOfCode.Day03Parser.parse_rucksacks splits list of rucksacks into a list of 2-tuples with each compartment as its own string" do
    input =
      """
      vJrwpWtwJWrh
      vJrwpBawJTrh
      """
    rucksacks = parse_rucksacks(input)
    assert rucksacks == {:ok, [{"vJrwpW", "twJWrh"}, {"vJrwpB", "awJTrh"}]}
  end
end
