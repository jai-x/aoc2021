defmodule Aoc2021.Day11 do
  @input Aoc2021.read_lines!("input/day11.txt")

  def run do
    octopi =
      @input
      |> Enum.join()
      |> String.graphemes()
      |> Enum.map(&String.to_integer/1)

    part1 =
      1..100
      |> Enum.reduce({0, octopi}, fn _, {flashes, octopi} ->
        new_octopi = step(octopi)
        new_flashes = Enum.count(new_octopi, &(&1 == 0))
        {flashes + new_flashes, new_octopi}
      end)
      |> elem(0)

    part2 =
      octopi
      |> Stream.unfold(fn octopi ->
        new_octopi = step(octopi)
        new_flashes = Enum.count(new_octopi, &(&1 == 0))

        if new_flashes == 100, do: nil, else: {:ok, new_octopi}
      end)
      |> Enum.count()
      |> then(&(&1 + 1))

    {:ok, part1, part2}
  end

  defp step(octopi) do
    octopi
    |> Enum.map(&(&1 + 1))
    |> flash_energy()
    |> Enum.map(fn x -> if x > 9, do: 0, else: x end)
  end

  defp flash_energy(octopi) do
    do_flash_energy(octopi, MapSet.new())
  end

  defp do_flash_energy(octopi, flashed) do
    to_propagate =
      octopi
      |> Enum.with_index()
      |> Enum.reject(fn {_x, i} -> MapSet.member?(flashed, i) end)
      |> Enum.filter(fn {x, _i} -> x > 9 end)
      |> Enum.map(&elem(&1, 1))
      |> MapSet.new()

    if MapSet.size(to_propagate) == 0 do
      octopi
    else
      energised_neighbours =
        to_propagate
        |> MapSet.to_list()
        |> Enum.map(&neighbours/1)
        |> List.flatten()
        |> Enum.frequencies()

      new_octopi =
        octopi
        |> Enum.with_index()
        |> Enum.map(fn {x, i} -> x + Map.get(energised_neighbours, i, 0) end)

      new_flashed =
        to_propagate
        |> MapSet.union(flashed)

      do_flash_energy(new_octopi, new_flashed)
    end
  end

  defp neighbours(idx) do
    cond do
      # top left
      idx == 0 -> [1, 10, 11]
      # top right
      idx == 9 -> [-1, 9, 10]
      # bottom left
      idx == 90 -> [1, -9, -10]
      # bottom right
      idx == 99 -> [-1, -10, -11]
      # top row
      idx in 1..8 -> [-1, 1, 9, 10, 11]
      # bottom row
      idx in 91..98 -> [-1, 1, -9, -10, -11]
      # left column
      rem(idx, 10) == 0 -> [-10, -9, 1, 11, 10]
      # right column
      rem(idx + 1, 10) == 0 -> [-10, -11, -1, 9, 10]
      # rest
      true -> [1, -1, -11, -10, -9, 9, 10, 11]
    end
    |> Enum.map(&(idx + &1))
  end
end
