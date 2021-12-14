defmodule Aoc2021.Day13 do
  @input Aoc2021.read_lines!("input/day13.txt")

  def run do
    {folds, dots} =
      @input
      |> Enum.reject(&(&1 == ""))
      |> Enum.split_with(&String.starts_with?(&1, "fold"))
      |> then(fn {folds, dots} ->
        folds =
          folds
          |> Enum.map(&String.replace_leading(&1, "fold along ", ""))
          |> Enum.map(&String.split(&1, "="))
          |> Enum.map(fn [axis, num] -> {axis, String.to_integer(num)} end)

        dots =
          dots
          |> Enum.map(&String.split(&1, ","))
          |> Enum.map(fn x -> Enum.map(x, &String.to_integer/1) end)
          |> Enum.map(&List.to_tuple/1)

        {folds, dots}
      end)

    part1 =
      folds
      |> List.first()
      |> List.wrap()
      |> apply_folds(dots)
      |> Enum.count()

    part2 =
      folds
      |> apply_folds(dots)
      |> dot_string()

    {:ok, part1, part2}
  end

  defp dot_string(dots) do
    w =
      dots
      |> Enum.map(&elem(&1, 0))
      |> Enum.max()
      |> then(&(&1 + 1))

    h =
      dots
      |> Enum.map(&elem(&1, 1))
      |> Enum.max()
      |> then(&(&1 + 1))

    coords = MapSet.new(dots)

    Enum.reduce(0..h, [], fn y, row ->
      row ++
        [
          Enum.reduce(0..w, "", fn x, col ->
            case MapSet.member?(coords, {x, y}) do
              true -> col <> "#"
              false -> col <> " "
            end
          end)
        ]
    end)
    |> then(&["⬇️⬇️⬇️" | &1])
    |> Enum.join("\n")
  end

  defp apply_folds(folds, dots) do
    Enum.reduce(folds, dots, fn {axis, num}, dots ->
      case axis do
        "y" ->
          Enum.map(dots, fn {x, y} ->
            cond do
              y < num -> {x, y}
              y > num -> {x, y - 2 * (y - num)}
            end
          end)

        "x" ->
          Enum.map(dots, fn {x, y} ->
            cond do
              x < num -> {x, y}
              x > num -> {x - 2 * (x - num), y}
            end
          end)
      end
    end)
    |> Enum.uniq()
  end
end
