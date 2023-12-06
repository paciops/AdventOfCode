module Day4

using AdventOfCode2023

function clean(vec::Vector{SubString{String}})
    return map(v -> parse(Int, v |> string |> strip), filter(!isempty, vec)) |> Set
end

function parseinput(input::String)
    parseline = (l) -> begin
        winning, numbers = split(split(l, ": ") |> last, "|")
        return clean(split(winning, " ")), clean(split(numbers, " "))
    end
    return map(parseline, filter(!isempty, split(input, '\n')))
end

function solve(input::String = AdventOfCode2023.readinput(4))
    calc = ((winning, numbers),) -> begin
        return intersect(winning, numbers) |> length
    end
    data = parseinput(input)
    lengths = map(calc, data)
    calculatecopies = (copies, (i, n)) -> begin
        for j = i+1:i+n
            copies[j] += copies[i]
        end
        return copies
    end
    return sum(n -> n > 0 ? 2^(n-1) : 0, lengths), reduce(calculatecopies, enumerate(lengths); init = fill(1, length(data))) |> sum
end
    
end