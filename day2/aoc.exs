input = File.read!("input.txt")
|> String.trim()
|> String.split("\n")
|> Enum.map(fn x -> String.trim(x) end)
|> Enum.map(fn x -> String.split(x," ") end)
|> Enum.map(fn [h|[t]] -> {a, _} = Integer.parse(t); [h | [a]]  end)


defmodule Part1 do
  def moves([head|tail], horacc, veracc) do
    [direction|[val]] = head
    case direction do
      "forward" -> moves(tail, horacc + val, veracc)
      "up" -> moves(tail, horacc, veracc - val)
      "down" -> moves(tail, horacc, veracc+val)
    end
    
  end

  def moves([], horacc, veracc) do
    horacc * veracc
  end
end

part1 = Part1.moves(input, 0,0)
:io.format("Day 2 - Part 1 = ~w~n", [part1])


defmodule Part2 do
  def moves([head|tail], horacc, veracc, aim) do
    [direction|[val]] = head
    case direction do
      "forward" -> moves(tail, horacc + val, veracc + (aim * val), aim)
      "up" -> moves(tail, horacc, veracc, aim - val)
      "down" -> moves(tail, horacc, veracc, aim + val)
    end
    
  end

  def moves([], horacc, veracc, _) do
    horacc * veracc
  end
end

part2 = Part2.moves(input, 0,0,0)
:io.format("Day 2 - Part 2 = ~w~n", [part2])
