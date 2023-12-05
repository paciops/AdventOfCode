module Day2

using AdventOfCode2023

function todict(array::Array{String})
    dict = Dict{String, Int}()
    for s in array
        i, k = split(s, " ")
        dict[k] = max(get(dict, k, 0), parse(Int, i))
    end
    return dict
end

function solve(input::String = AdventOfCode2023.readinput(2); partTwo = false)
    limit = Dict("red" => 12, "green" => 13, "blue" => 14)
    acc = 0
    product = 0
    for (i, l) in split(input, '\n') |> enumerate
        cubes = split(replace(split(l, ": ") |> last, ", " => "_", "; " => "_"), "_") .|> String |> todict
        if (keys(limit) .|> k -> cubes[k] <= limit[k]) |> all
            acc += i
        end
        product += prod(values(cubes))
    end
    return acc, product
end

end