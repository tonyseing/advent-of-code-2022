defmodule AdventOfCode.Day02Test do
  use ExUnit.Case

  import AdventOfCode.Day02
  import AdventOfCode.RockPaperScissorsParser

  test "part1" do
    input =
      """
      A Y
      B X
      C Z
      """

    result = part1(input)

    assert result == 15
  end

  test "part2" do
    input =
      """
      A Y
      B X
      C Z
      C Z
      A X
      B Z
      """
    # rock scissors 4 / DRAW
    # paper paper 1 / LOSE
    # scissors rock 7 / WIN
    # scissors rock 7 / WIN
    # rock scissors 3 / LOSE
    # paper scissors 9 / WIN

    result = part2(input)

    assert result == 31
  end

  test "RockPaperScissorsParser" do
    plays = parse_rps_lines(
      """
      A X
      B Y
      C Z
      """
    )
    assert match?({:ok, ["A", "X", "B", "Y", "C", "Z"], _, _, _, _}, plays)
  end

  test "parse_plays" do
    input =
      """
      C Z
      C Z
      A X
      A X
      """
    result = parse_plays(input)

    assert result == {:ok, [
      ["C", "Z"],
      ["C", "Z"],
      ["A", "X"],
      ["A", "X"]
    ]}
  end

  test "score_play" do
    assert score_play("A", "X") == 4
    assert score_play("A", "Y") == 8
    assert score_play("A", "Z") == 3
    assert score_play("B", "X") == 1
    assert score_play("B", "Y") == 5
    assert score_play("B", "Z") == 9
    assert score_play("C", "X") == 7
    assert score_play("C", "Y") == 2
    assert score_play("C", "Z") == 6
  end

  test "translate_play" do
    assert translate_play("A") == :rock
    assert translate_play("X") == :rock
    assert translate_play("B") == :paper
    assert translate_play("Y") == :paper
    assert translate_play("C") == :scissors
    assert translate_play("Z") == :scissors
  end

  test "outcome_score" do
    assert outcome_score(:rock, :rock) == 3
    assert outcome_score(:rock, :paper) == 6
    assert outcome_score(:rock, :scissors) == 0

    assert outcome_score(:paper, :rock) == 0
    assert outcome_score(:paper, :paper) == 3
    assert outcome_score(:paper, :scissors) == 6

    assert outcome_score(:scissors, :rock) == 6
    assert outcome_score(:scissors, :paper) == 0
    assert outcome_score(:scissors, :scissors) == 3
  end

  test "shape_score" do
    assert shape_score(:rock) == 1
    assert shape_score(:paper) == 2
    assert shape_score(:scissors) == 3
  end
end
