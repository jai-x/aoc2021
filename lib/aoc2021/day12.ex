defmodule Aoc2021.Day12 do
  @input Aoc2021.read_lines!("input/day12.txt")

  def run do
    cave_map =
      @input
      |> Enum.map(&String.split(&1, "-"))
      |> Enum.reduce(%{}, fn [l, r], map ->
        map
        |> Map.update(l, [r], &[r | &1])
        |> Map.update(r, [l], &[l | &1])
      end)

    part1 = paths(cave_map, "start", MapSet.new(), false)
    part2 = paths(cave_map, "start", MapSet.new(), true)

    {:ok, part1, part2}
  end

  defp paths(_map, "end", _visited, _allow_revisit), do: 1

  defp paths(map, node, visited, true) do
    if MapSet.member?(visited, node) do
      path_map(map, node, visited, false)
    else
      path_map(map, node, visited, true)
    end
  end

  defp paths(map, node, visited, false) do
    if MapSet.member?(visited, node) do
      0
    else
      path_map(map, node, visited, false)
    end
  end

  defp path_map(map, node, visited, allow_revisit) do
    visited = if lowercase?(node), do: MapSet.put(visited, node), else: visited

    map
    |> Map.get(node)
    |> Enum.reject(&(&1 == "start"))
    |> Enum.map(fn n -> paths(map, n, visited, allow_revisit) end)
    |> Enum.sum()
  end

  defp lowercase?(str), do: String.downcase(str) == str
end
