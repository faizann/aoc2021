use Bitwise

input =
  File.read!("input.txt")
  |> String.trim()
  |> String.trim("\n")
  |> String.split("\n")

gamma_bits = input
  |> Enum.map(fn x -> String.to_charlist(x) end)
  |> List.zip() # pivot the data to count as lists.
  |> Enum.map(fn x -> Tuple.to_list(x) end)
  |> Enum.map(fn a -> 
    Enum.map_reduce(a,0, fn x, acc ->  # count how many 1s are in the list.
      case x do # 48 = '0'
        48 -> {x, acc} 
        _ -> {x, acc + 1}
      end
    end)
  end)
  |> Enum.map(fn {x,y} -> 
    case y > length(x)/2 do
      true -> '1'
      _ -> '0'
    end
  end)

epsilon_bits = Enum.map(gamma_bits, fn x -> 
  # IO.inspect(x)
  case x do
    '0' -> '1'
    _ -> '0'
  end
end)

{gamma, _} = Integer.parse(gamma_bits
|> Enum.join(),2)
{epsilon, _} = Integer.parse(epsilon_bits
|> Enum.join(),2)
power = gamma * epsilon
:io.format("Day 3 - Part 1 = ~w~n", [power])

# Day 3
defmodule Reading do
  def read(type, data) when is_list(data) and length(data) > 1 do
    read(type, data,0,String.length(Enum.at(data,0)))
  end
  def read(type, data, bitIndex, max) when bitIndex < max and length(data) > 1 do
    common = find_common(data,bitIndex)
    filtered_data = Enum.filter(data,fn item -> 
      case type do
        :oxygen -> String.at(item,bitIndex) == common
        _ -> String.at(item,bitIndex) != common
      end
    end)
    
    read(type, filtered_data, bitIndex+1, max)
  end
  def read(_, data, _, _) when length(data) == 1 do
    {num, _} = Integer.parse(Enum.at(data,0),2)
    num
  end

  defp find_common(data, index) do
    item_len = length(data)
    count1 = Enum.count(data, fn item -> 
      case String.at(item,index) do
        "0" -> false
        _ -> true
      end
    end)
    case (count1 < item_len/2) do
      true -> "0"
      _ -> "1"
    end
  end
end


oxygen = Reading.read(:oxygen, input)
co2_scrub = Reading.read(:co2, input)
life_support = oxygen * co2_scrub
:io.format("Day 3 - Part 2 = ~w~n", [life_support])
