defmodule Aoc2021.Day5 do
  @input Aoc2021.read_lines!("input/day5.txt")

  def run do
    lines = parse_lines(@input)

    part1 = overlaps_orthogonal(lines)
    part2 = overlaps_all(lines)

    {:ok, part1, part2}
  end

  defp overlaps_orthogonal(lines) do
    lines
    |> Enum.filter(&is_orthogonal/1)
    |> overlaps_all()
  end

  defp overlaps_all(lines) do
    lines
    |> Enum.map(&expand_line/1)
    |> List.flatten()
    |> Enum.frequencies()
    |> Enum.filter(fn {{_x, _y}, count} -> count > 1 end)
    |> Enum.count()
  end

  defp expand_line({{x1, y1}, {x2, y2}}) do
    cond do
      x1 == x2 -> Enum.map(y1..y2, &{x1, &1})
      y1 == y2 -> Enum.map(x1..x2, &{&1, y1})
      true -> Enum.zip(x1..x2, y1..y2)
    end
  end

  defp is_orthogonal({{x1, y1}, {x2, y2}}), do: x1 == x2 || y1 == y2

  defp parse_lines(input) do
    input
    |> Enum.map(fn l -> String.split(l, [",", "->"]) end)
    |> Enum.map(fn l -> Enum.map(l, &String.trim/1) end)
    |> Enum.map(fn l -> Enum.map(l, &String.to_integer/1) end)
    |> Enum.map(fn [x1, y1, x2, y2] -> {{x1, y1}, {x2, y2}} end)
  end
end
