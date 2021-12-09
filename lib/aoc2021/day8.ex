defmodule Aoc2021.Day8 do
  @input Aoc2021.read_lines!("input/day8.txt")

  def run do
    {signals, outputs} =
      @input
      |> Enum.map(&String.split/1)
      |> Enum.map(fn x -> Enum.reject(x, &(&1 == "|")) end)
      |> Enum.map(fn x -> Enum.map(x, &String.graphemes/1) end)
      |> Enum.map(fn x -> Enum.map(x, &MapSet.new/1) end)
      |> Enum.reduce({[], []}, fn line, {sigs, outs} ->
        {s, o} = Enum.split(line, 10)
        {sigs ++ [s], outs ++ [o]}
      end)

    part1 =
      outputs
      |> List.flatten()
      |> Enum.map(&MapSet.size/1)
      |> Enum.filter(&(&1 in [2, 4, 3, 7]))
      |> Enum.count()

    part2 =
      signals
      |> Enum.map(&signal_map/1)
      |> Enum.zip(outputs)
      |> Enum.map(fn {map, output} -> Enum.map(output, &map[&1]) end)
      |> Enum.map(&Enum.join/1)
      |> Enum.map(&String.to_integer/1)
      |> Enum.sum()

    {:ok, part1, part2}
  end

  defp signal_map(signals) do
    map =
      signals
      |> Enum.reduce(%{}, fn s, map ->
        case MapSet.size(s) do
          2 -> Map.put(map, 1, s)
          4 -> Map.put(map, 4, s)
          3 -> Map.put(map, 7, s)
          7 -> Map.put(map, 8, s)
          _ -> map
        end
      end)

    {[nine], maybe_56} =
      signals
      |> Enum.reject(&(&1 in Map.values(map)))
      |> Enum.filter(&MapSet.subset?(MapSet.difference(map[4], map[1]), &1))
      |> Enum.split_with(&MapSet.subset?(map[4], &1))

    map =
      map
      |> Map.put(9, nine)

    {[six], [five]} =
      maybe_56
      |> Enum.split_with(&MapSet.subset?(MapSet.difference(map[8], map[9]), &1))

    map =
      map
      |> Map.put(5, five)
      |> Map.put(6, six)

    {maybe_03, [two]} =
      signals
      |> Enum.reject(&(&1 in Map.values(map)))
      |> Enum.split_with(&MapSet.subset?(map[1], &1))

    {[zero], [three]} =
      maybe_03
      |> Enum.split_with(&MapSet.subset?(MapSet.difference(map[8], map[9]), &1))

    map =
      map
      |> Map.put(0, zero)
      |> Map.put(2, two)
      |> Map.put(3, three)

    Map.new(map, fn {k, v} -> {v, k} end)
  end
end
