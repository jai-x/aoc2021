defmodule Aoc2021.Day7 do
  @input Aoc2021.read_lines!("input/day7.txt")

  def run do
    crabs =
      @input
      |> List.first()
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)

    part1 =
      crabs
      |> median()
      |> linear_fuel(crabs)

    part2 =
      crabs
      |> mean()
      |> then(fn x -> [floor(x), ceil(x)] end)
      |> Enum.map(fn x -> exponential_fuel(x, crabs) end)
      |> Enum.min()

    {:ok, part1, part2}
  end

  defp linear_fuel(movement, crabs) do
    crabs
    |> Enum.map(&(&1 - movement))
    |> Enum.map(&abs/1)
    |> Enum.sum()
  end

  defp exponential_fuel(movement, crabs) do
    crabs
    |> Enum.map(&(&1 - movement))
    |> Enum.map(&abs/1)
    |> Enum.map(&(0..&1))
    |> Enum.map(&Enum.sum/1)
    |> Enum.sum()
  end

  defp median(list), do: list |> Enum.sort() |> Enum.at(div(length(list), 2))
  defp mean(list), do: mean(list, 0, 0)
  defp mean([], 0, 0), do: nil
  defp mean([], sum, len), do: sum / len
  defp mean([head | tail], sum, len), do: mean(tail, sum + head, len + 1)
end
