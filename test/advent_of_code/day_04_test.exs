defmodule AdventOfCode.Day04Test do
  use ExUnit.Case

  import AdventOfCode.Day04

  test "part1" do
    input =
      """
      2-4,6-8
      2-3,4-5
      5-7,7-9
      2-8,3-7
      6-6,4-6
      2-6,4-8
      """
    result = part1(input)

    assert result == 2
  end

  test "part2" do
    input =
      """
      5-7,7-9
      2-8,3-7
      6-6,4-6
      2-6,4-8
      """
    result = part2(input)

    assert result == 4
  end

  test "range_parser" do
    input = "7-9"
    result = range_parser(input)
    assert match?({:ok, [7, 9], _, _, _, _ }, result)
  end

  test "tuple_range_parser" do
    input = "2-4,7-9"
    result = tuple_range_parser(input)
    assert match?({:ok, [2, 4, 7, 9], _, _, _, _ }, result)
  end

  test "assignments_parser_helper" do
    input =
      """
      2-4,6-8
      2-3,4-5
      5-7,8-10
      2-8,3-7
      """
      result = assignments_parser_helper(input)
      assert match?({:ok, [2, 4, 6, 8, 2, 3, 4, 5, 5, 7, 8, 10, 2, 8, 3, 7], _, _, _, _}, result)
  end

  test "parse_assignments" do
    input =
      """
      2-4,6-88
      2-3,4-5
      5-7,14-20
      2-8,7-9
      """
      result = parse_assignments(input)
      assert {:ok, [[[2, 4], [6, 88]], [[2, 3], [4, 5]], [[5, 7], [14, 20]], [[2, 8], [7, 9]]]} == result
  end

  test "ranges_have_overlap should return true when there is any overlap between ranges" do
    range_1 = [2, 4]
    range_2 = [4, 8]
    result = ranges_have_overlap(range_1, range_2)
    assert result == true
  end

  test "ranges_have_overlap should return false when there is not any overlap between ranges" do
    range_1 = [4, 9]
    range_2 = [1, 3]
    result = ranges_have_overlap(range_1, range_2)
    assert result == false
  end
end
