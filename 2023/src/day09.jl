module Day9

using Folds

using AdventOfCode2023

notallsame(x) = any(y -> y !== first(x), x)

function calclast(row::Array{Int})
    deltas = Vector([diff(row)])
    while notallsame(last(deltas))
        push!(deltas, diff(last(deltas)))
    end
    return sum(last.(deltas)) + last(row), first(row) - reduce((acc, n) -> n - acc, first.(deltas) |> reverse)
end

function solve(input::String = AdventOfCode2023.readinput(9))
    rows = filter(!isempty, split(input, '\n')) .|> line -> (split(line, ' ') .|> AdventOfCode2023.parseint)
    return reduce((acc, row) -> acc .+ calclast(row), rows; init=(0,0))
end

end