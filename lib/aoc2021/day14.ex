defmodule Aoc2021.Day14 do
  @input Aoc2021.read_lines!("input/day14.txt")

  def run do
    chain =
      @input
      |> List.first()
      |> String.graphemes()

    rules =
      @input
      |> Enum.drop(2)
      |> Enum.map(&String.split(&1, " -> "))
      |> Enum.map(&List.to_tuple/1)
      |> Enum.into(Map.new())

    part1 = polymerise(chain, rules, 10)

    part2 = polymerise(chain, rules, 40)

    {:ok, part1, part2}
  end

  defp polymerise(chain, rules, steps) do
    letters =
      chain
      |> Enum.frequencies()

    pairs =
      chain
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.map(&Enum.join/1)
      |> Enum.frequencies()

    1..steps
    |> Enum.reduce({letters, pairs}, fn _, {l, p} -> polymerise_step(l, p, rules) end)
    |> elem(0)
    |> Map.values()
    |> then(fn x -> Enum.max(x) - Enum.min(x) end)
  end

  defp polymerise_step(letters, pairs, rules) do
    Enum.reduce(pairs, {letters, %{}}, fn {pair, num}, {letters, pairs} ->
      ch = Map.get(rules, pair)

      new_letters =
        letters
        |> Map.update(ch, num, &(&1 + num))

      new_pairs =
        pairs
        |> Map.update(String.first(pair) <> ch, num, &(&1 + num))
        |> Map.update(ch <> String.last(pair), num, &(&1 + num))

      {new_letters, new_pairs}
    end)
  end
end
