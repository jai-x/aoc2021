defmodule Aoc2021.Day17 do
  @input Aoc2021.read_lines!("input/day17.txt")

  def run do
    target = {{_min_x, max_x}, {min_y, max_y}} = parse(@input)

    part1 =
      0..abs(min_y + 1)
      |> Enum.filter(fn vy -> in_target?({0, vy}, {{0, 0}, {min_y, max_y}}) end)
      |> List.last()
      |> then(fn max_vy -> simulate(0, max_vy, 0, min_y) end)
      |> Enum.map(&elem(&1, 1))
      |> Enum.max()

    part2 =
      cart(0..max_x, min_y..abs(min_y + 1))
      |> Enum.filter(&in_target?(&1, target))
      |> Enum.count()

    {:ok, part1, part2}
  end

  defp cart(l1, l2) do
    for i <- l1, j <- l2, do: {i, j}
  end

  defp in_target?({vx, vy}, {{min_x, max_x}, {min_y, max_y}}) do
    {last_x, last_y} = simulate(vx, vy, max_x, min_y) |> Enum.at(-1)

    last_x in min_x..max_x && last_y in min_y..max_y
  end

  defp simulate(vx, vy, max_x, min_y) do
    Stream.unfold({{0, 0}, {vx, vy}}, fn state = {{x, y}, _} ->
      case x > max_x || y < min_y do
        true -> nil
        false -> {{x, y}, step(state)}
      end
    end)
  end

  defp step({{x, y}, {vx, vy}}) do
    new_x = x + vx
    new_y = y + vy

    new_vx = if vx > 0, do: vx - 1, else: 0
    new_vy = vy - 1

    {{new_x, new_y}, {new_vx, new_vy}}
  end

  defp parse(input) do
    input
    |> List.first()
    |> String.replace_leading("target area: ", "")
    |> String.replace(~r/([xy]=)|,/, "")
    |> String.replace("..", " ")
    |> String.split()
    |> Enum.map(&String.to_integer/1)
    |> then(fn [x, xx, y, yy] -> {{x, xx}, {y, yy}} end)
  end
end
