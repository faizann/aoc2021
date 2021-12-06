# Read and parse data.
input = File.read!("input.txt")
|> String.trim()
|> String.split("\n") 
|> Enum.map(fn x -> 
  y=Integer.parse(String.trim(x))
  elem(y,0)
end)


# Day 1
part1 = Enum.chunk_every(input, 2,1,:discard)
|> Enum.filter(fn [h|[t]] -> h < t  end)
|> Enum.count()

:io.format("Day 1 - Part 1 = ~w~n",[part1])


part2 = Enum.chunk_every(input, 3,1,:discard)
|> Enum.map(fn x -> Enum.sum(x) end)
|> Enum.chunk_every(2,1,:discard)
|> Enum.filter(fn [h|[t]] -> h < t  end)
|> Enum.count()
:io.format("Day 1 - Part 2 = ~w~n",[part2])
