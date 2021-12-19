defmodule Aoc2021.Day16 do
  import Bitwise

  @input Aoc2021.read_lines!("input/day16.txt")

  def run do
    packet =
      @input
      |> List.first()
      |> Base.decode16!()
      |> decode()
      |> elem(1)

    part1 = packet[:versions] |> Enum.sum()

    part2 = packet[:numbers] |> List.first()

    {:ok, part1, part2}
  end

  def decode(<<rest::bits>>) do
    decode(rest, %{versions: [], numbers: []})
  end

  # extract version
  def decode(<<v::3, rest::bits>>, state) do
    new_state = Map.update!(state, :versions, &[v | &1])

    decode_type(rest, new_state)
  end

  # literal
  def decode_type(<<4::3, rest::bits>>, state) do
    decode_literal(rest, 0, state)
  end

  # op bit len
  def decode_type(<<id::3, 0::1, sublen::15, rest::bits>>, state) do
    <<subpackets::size(sublen)-bits, rest::bits>> = rest

    numbers = state[:numbers]

    state = decode_bitlen(subpackets, Map.put(state, :numbers, []))

    result = operation(id, state[:numbers])

    {rest, Map.put(state, :numbers, [result | numbers])}
  end

  # op bit count
  def decode_type(<<id::3, 1::1, subcount::11, rest::bits>>, state) do
    numbers = state[:numbers]

    {rest, state} = decode_bitcount(subcount, rest, Map.put(state, :numbers, []))

    result = operation(id, state[:numbers])

    {rest, Map.put(state, :numbers, [result | numbers])}
  end

  def decode_literal(<<1::1, part::4, rest::bits>>, acc, state) do
    decode_literal(rest, (acc <<< 4) + part, state)
  end

  def decode_literal(<<0::1, part::4, rest::bits>>, acc, state) do
    {rest, Map.update!(state, :numbers, &[(acc <<< 4) + part | &1])}
  end

  def decode_bitlen(<<>>, state) do
    state
  end

  def decode_bitlen(subpackets, state) do
    {rest, state} = decode(subpackets, state)
    decode_bitlen(rest, state)
  end

  def decode_bitcount(0, rest, state) do
    {rest, state}
  end

  def decode_bitcount(subcount, rest, state) do
    {rest, state} = decode(rest, state)
    decode_bitcount(subcount - 1, rest, state)
  end

  def operation(0, numbers), do: Enum.sum(numbers)
  def operation(1, numbers), do: Enum.product(numbers)
  def operation(2, numbers), do: Enum.min(numbers)
  def operation(3, numbers), do: Enum.max(numbers)
  # 5 & 6 comparisions are reversed as lists are appended at front
  def operation(5, [a, b]), do: if(a < b, do: 1, else: 0)
  def operation(6, [a, b]), do: if(a > b, do: 1, else: 0)
  def operation(7, [a, b]), do: if(a == b, do: 1, else: 0)
end
