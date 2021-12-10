defmodule Aoc2021.Day9 do
  @input Aoc2021.read_lines!("input/day9.txt")

  def run do
    {w, h, tubes} =
      @input
      |> then(&{&1 |> List.first() |> String.length(), &1 |> Enum.count(), &1})
      |> then(fn {w, h, t} -> {w, h, Enum.join(t)} end)
      |> then(fn {w, h, t} -> {w, h, String.graphemes(t)} end)
      |> then(fn {w, h, t} -> {w, h, Enum.map(t, &String.to_integer/1)} end)

    low_points =
      tubes
      |> Enum.with_index()
      |> Enum.map(fn {x, i} -> {x, i, neighbours(i, w, h, tubes)} end)
      |> Enum.map(fn {x, i, n} -> {x, i, Enum.map(n, &elem(&1, 0))} end)
      |> Enum.map(fn {x, i, n} -> {x, i, Enum.min(n)} end)
      |> Enum.filter(fn {x, _i, n} -> x < n end)
      |> Enum.map(&Tuple.delete_at(&1, 2))

    part1 =
      low_points
      |> Enum.map(fn {x, _} -> x + 1 end)
      |> Enum.sum()

    part2 =
      low_points
      |> Enum.map(&slopes(&1, w, h, tubes))
      |> Enum.map(&Enum.count/1)
      |> Enum.sort()
      |> Enum.reverse()
      |> Enum.take(3)
      |> Enum.product()

    {:ok, part1, part2}
  end

  defp slopes({x, i}, w, h, tubes), do: do_slopes([], [{x, i}], w, h, tubes)

  defp do_slopes(seen, [], _w, _h, _tubes), do: seen

  defp do_slopes(seen, unseen, w, h, tubes) do
    new_unseen =
      unseen
      |> Enum.map(fn {_x, i} -> neighbours(i, w, h, tubes) end)
      |> List.flatten()
      |> Enum.reject(fn {x, _i} -> x == 9 end)
      |> Enum.reject(&(&1 in seen))

    new_seen =
      seen
      |> Enum.concat(unseen)
      |> Enum.uniq()

    do_slopes(new_seen, new_unseen, w, h, tubes)
  end

  defp neighbours(i, w, h, tubes) do
    north_south =
      [i + w, i - w]
      |> Enum.reject(&(&1 < 0))
      |> Enum.reject(&(&1 > h * w - 1))

    west =
      cond do
        i == w * h - 1 -> i - 1
        rem(i, w) == 0 -> nil
        true -> i - 1
      end

    east =
      cond do
        i == 0 -> i + 1
        rem(i + 1, w) == 0 -> nil
        true -> i + 1
      end

    Enum.concat(north_south, [west, east])
    |> Enum.reject(&is_nil/1)
    |> Enum.map(&{Enum.at(tubes, &1), &1})
  end
end
