module Day5

using ProgressMeter

using AdventOfCode2023


parseint =  (n) -> parse(Int, n)

function parseinput(input::String)
    maps = []
    data = split(input, "\n\n")
    seeds = split(first(data), ' ')[2:end] .|> parseint
    f = (l) -> begin
        destination_range, source_range, range_length = parseint.(split(l, ' '))
        return (destination_range:destination_range+range_length-1, source_range:source_range+range_length-1)
    end
    for d in data[2:end]
        numbers = split(d, '\n')[2:end]
        value = map(f, numbers)
        push!(maps, value)
    end

    return seeds, maps
end

reshapearray = (array) -> reshape(array, 2, : )' |> eachrow .|> r -> r[1]:r[1]+r[2]-1

function solve(input::String = AdventOfCode2023.readinput(5))
    seeds, maps =  parseinput(input)
    seedsparttwo = reshapearray(seeds)
    checkn = (n, map) -> begin
        index = findfirst(((dest, src),) -> n in src, map)
        if !isnothing(index)
            dest, src = map[index]
            return  n - src[1] + dest[1] 
        end
        return n
    end
    computepath = (seed) -> reduce(checkn, maps; init=seed)
    m = typemax(Int)
    @showprogress for two in seedsparttwo
        n = 1 + two[end] - two[1]
        
        values = Array{Int}(undef, n)
        for (i, seed) in enumerate(two)
            # @show i, seed
            values[i] = computepath(seed)
        end
        m = min(m, minimum(values))
    end
    return minimum(computepath, seeds), m
end

end