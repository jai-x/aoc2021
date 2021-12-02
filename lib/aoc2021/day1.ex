defmodule Aoc2021.Day1 do
  @input Aoc2021.read_lines!("input/day1.txt")

  def run do
    measurements = @input |> Enum.map(&String.to_integer/1)

    part1 = measurements |> count_increase

    part2 =
      measurements
      |> Enum.chunk_every(3, 1, :discard)
      |> Enum.map(&Enum.sum/1)
      |> count_increase

    {:ok, part1, part2}
  end

  defp count_increase(list) do
    list
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.reduce(0, fn [l, r], count -> if r > l, do: count + 1, else: count end)
  end
end
