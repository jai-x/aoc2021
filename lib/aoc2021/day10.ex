defmodule Aoc2021.Day10 do
  @input Aoc2021.read_lines!("input/day10.txt")

  def run do
    parsed =
      @input
      |> Enum.map(&String.graphemes/1)
      |> Enum.map(&parse/1)

    part1 =
      parsed
      |> Enum.filter(&is_binary/1)
      |> Enum.map(&illegal_score/1)
      |> Enum.sum()

    part2 =
      parsed
      |> Enum.filter(&is_list/1)
      |> Enum.map(fn x -> Enum.map(x, &autocomplete_score/1) end)
      |> Enum.map(fn x -> Enum.reduce(x, 0, &(&2 * 5 + &1)) end)
      |> Enum.sort()
      |> middle()

    {:ok, part1, part2}
  end

  defp parse(charlist) do
    Enum.reduce_while(charlist, [], fn char, stack ->
      cond do
        char in ["(", "[", "{", "<"] ->
          {:cont, [invert(char) | stack]}

        char in [")", "]", "}", ">"] ->
          case stack do
            [^char | rest] -> {:cont, rest}
            _ -> {:halt, char}
          end
      end
    end)
  end

  defp middle(list) do
    Enum.at(list, div(Enum.count(list), 2))
  end

  def illegal_score(char) do
    case char do
      ")" -> 3
      "]" -> 57
      "}" -> 1197
      ">" -> 25137
    end
  end

  def autocomplete_score(char) do
    case char do
      ")" -> 1
      "]" -> 2
      "}" -> 3
      ">" -> 4
    end
  end

  defp invert(char) do
    case char do
      "(" -> ")"
      "[" -> "]"
      "{" -> "}"
      "<" -> ">"
    end
  end
end
