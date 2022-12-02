defmodule AdventOfCode.RockPaperScissorsParser do
  import NimbleParsec

  play_1 = choice([string("A"), string("B"), string("C")])
  separator = string(" ")
  play_2 = choice([string("X"), string("Y"), string("Z")])
  line_separator = string("\n")

  line = play_1
    |> concat(ignore(separator))
    |> concat(play_2)
    |> concat(ignore(line_separator))

  lines = times(line, min: 1)

  defparsec(:parse_rps_lines, lines)


end

defmodule AdventOfCode.Day02 do
  @tie_score 3
  @lose_score 0
  @win_score 6

  def parse_plays(input) do
    case AdventOfCode.RockPaperScissorsParser.parse_rps_lines(input) do
      {:ok, plays, _, _, _, _} -> {:ok, plays |> Enum.chunk_every(2) }
      _ -> {:error, []}
    end
  end

  def part1(input) do
    input
    |> parse_plays
    |> case do
      {:ok, plays} ->
        plays
          |> Enum.map(fn ([pp_1, pp_2]) -> AdventOfCode.Day02.score_play(pp_1, pp_2) end)
          |> Enum.sum
      _ -> 0
    end
  end

  def part2(_args) do
  end

  def score_play(play_1, play_2) do
    outcome_score(translate_play(play_1), translate_play(play_2)) + shape_score(translate_play(play_2))
  end

  def outcome_score(play_1, play_2) do
    case {play_1, play_2} do
      {:rock, :rock} -> @tie_score
      {:rock, :paper} -> @win_score
      {:rock, :scissors} -> @lose_score
      {:paper, :rock} -> @lose_score
      {:paper, :paper} -> @tie_score
      {:paper, :scissors} -> @win_score
      {:scissors, :rock} -> @win_score
      {:scissors, :paper} -> @lose_score
      {:scissors, :scissors} -> @tie_score
    end
  end

  def shape_score(:rock), do: 1
  def shape_score(:paper), do: 2
  def shape_score(:scissors), do: 3

  @spec translate_play(<<_::8>>) :: :paper | :rock | :scissors
  def translate_play(play) do
    case play do
      "A" -> :rock
      "X" -> :rock
      "B" -> :paper
      "Y" -> :paper
      "C" -> :scissors
      "Z" -> :scissors
    end
  end
end
