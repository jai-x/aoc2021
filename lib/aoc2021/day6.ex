defmodule Aoc2021.Day6 do
  @input Aoc2021.read_lines!("input/day6.txt")

  def run do
    fish = parse(@input)

    part1 = simulate(fish, 80)
    part2 = simulate(fish, 256)

    {:ok, part1, part2}
  end

  defp parse(input) do
    input
    |> List.first()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> Enum.reduce(List.duplicate(0, 9), fn x, list ->
      List.update_at(list, x, &(&1 + 1))
    end)
  end

  defp simulate(fish, days) do
    1..days
    |> Enum.reduce(fish, fn _day, fish -> age(fish) end)
    |> Enum.sum()
  end

  defp age([head | tail]) do
    fish = tail ++ [head]
    List.update_at(fish, 6, &(&1 + Enum.at(fish, 8)))
  end
end
