defmodule Aoc2021.Day15 do
  @input Aoc2021.read_lines!("input/day15.txt")

  def run do
    part1 =
      @input
      |> small_cave()
      |> dijkstra()

    part2 =
      @input
      |> big_cave()
      |> dijkstra()

    {:ok, part1, part2}
  end

  def small_cave(input) do
    w =
      input
      |> List.first()
      |> String.length()

    h =
      input
      |> Enum.count()

    risks =
      input
      |> Enum.join()
      |> String.graphemes()
      |> Enum.map(&String.to_integer/1)
      |> Enum.with_index()
      |> Enum.into(%{}, fn {v, k} -> {k, v} end)

    {w, h, risks}
  end

  def big_cave(input) do
    w =
      input
      |> List.first()
      |> String.length()
      |> Kernel.*(5)

    h =
      input
      |> Enum.count()
      |> Kernel.*(5)

    risks =
      input
      |> Enum.map(&String.graphemes/1)
      |> Enum.map(fn l -> Enum.map(l, &String.to_integer/1) end)
      |> Enum.map(&expand_row(&1, 5))
      |> List.flatten()
      |> expand_row(5)
      |> Enum.with_index()
      |> Enum.into(%{}, fn {v, k} -> {k, v} end)

    {w, h, risks}
  end

  def expand_row(row, num) do
    Enum.reduce(0..(num - 1), [], fn i, acc ->
      out =
        row
        |> Enum.map(&(&1 + i))
        |> Enum.map(fn x -> if x > 9, do: x - 9, else: x end)

      acc ++ out
    end)
  end

  def dijkstra(cave = {w, h, _risks}) do
    dists =
      List.duplicate(:infinity, w * h)
      |> Enum.with_index()
      |> Enum.into(%{}, fn {v, k} -> {k, v} end)
      |> Map.put(0, 0)

    visited = MapSet.new()

    frontier = Map.new([{0, 0}])

    visit_last(dists, visited, frontier, cave)
  end

  def visit_last(dists, visited, frontier, cave = {w, h, _}) do
    last = w * h - 1

    case MapSet.member?(visited, last) do
      true -> Map.get(dists, last)
      false -> find_min(dists, visited, frontier, cave)
    end
  end

  def find_min(dists, visited, frontier, cave) do
    # poor mans prio queue pop
    min =
      frontier
      |> Enum.min_by(fn {_k, v} -> v end)
      |> elem(0)

    new_frontier = Map.delete(frontier, min)

    case MapSet.member?(visited, min) do
      true -> visit_last(dists, visited, new_frontier, cave)
      false -> enqueue_neighbours(dists, visited, new_frontier, cave, min)
    end
  end

  def enqueue_neighbours(dists, visited, frontier, cave = {w, h, risk}, min) do
    new_visited = MapSet.put(visited, min)

    n_dists =
      neighbours(min, w, h)
      |> Enum.map(fn i -> {i, Map.get(risk, i)} end)
      |> Enum.map(fn {k, v} -> {k, v + Map.get(dists, min)} end)
      |> Enum.into(%{})

    new_dists =
      dists
      |> Map.merge(n_dists, fn _k, v1, v2 -> if v2 < v1, do: v2, else: v1 end)

    # poor mans prio queue insert
    new_frontier =
      frontier
      |> Map.merge(n_dists, fn _k, v1, v2 -> if v2 < v1, do: v2, else: v1 end)

    visit_last(new_dists, new_visited, new_frontier, cave)
  end

  def neighbours(idx, w, h) do
    cond do
      # top left
      idx == 0 ->
        [1, w]

      # top right
      idx == w - 1 ->
        [-1, w]

      # bottom left
      idx == w * h - w ->
        [1, -w]

      # bottom right
      idx == w * h - 1 ->
        [-1, -w]

      # top row
      idx in 1..(w - 2) ->
        [-1, 1, w]

      # bottom row
      idx in (w * h - w)..(w * h - 2) ->
        [1, -1, -w]

      # left column
      rem(idx, w) == 0 ->
        [1, w, -w]

      # right column
      rem(idx + 1, w) == 0 ->
        [-1, w, -w]

      # rest
      true ->
        [1, -1, -w, w]
    end
    |> Enum.map(&(&1 + idx))
  end
end
