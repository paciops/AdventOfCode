using DataStructures
using ProgressMeter

START = "AA"

function parseValve(data::Vector{String})
    valves = findfirst(el -> el == "valves", data)
    if isnothing(valves)
        valves = findfirst(el -> el == "valve", data)
    end
    return replace.(data[valves+1:end], "," => "")
end

function parseInput(filename::String)
    valves = Dict{String, Int}()
    tunnels = Dict{String, Array{String}}()
    open(filename) do file
        for line in eachline(file)
            data = String.(split(line, " "))
            name = data[2]
            flow = parse(Int, replace(data[5], ";"=>" ", "rate="=>" "))
            targets = parseValve(data)
            valves[name] = flow
            tunnels[name] = targets
        end
    end
    return valves, tunnels
end

function createdistance(valves::Dict{String, Int}, tunnels::Dict{String, Array{String}})
    positivefloworstart = filter(((v,f),) -> v == START || f > 0, valves)
    distances = Dict{String, Dict{String, Int}}()
    for (valve, flow) in positivefloworstart
        distances[valve] = Dict(valve => 0, START => 0)
        visited = Set{String}([valve])
        queue = Vector{Tuple{String, Int}}([(valve, 0)])
        while !isempty(queue)
            position, distance = popfirst!(queue)
            for neighbor in tunnels[position]
                if !(neighbor in visited)
                    push!(visited, neighbor)
                    if valves[neighbor] > 0
                        distances[valve][neighbor] = distance + 1
                    end
                    push!(queue, (neighbor, distance + 1))
                end
            end
        end
        delete!(distances[valve],valve)
        if valve != START
            delete!(distances[valve], START)
        end
    end
    return distances
end

function cachedfs(time::Int, valve::T, mask::Set{T}, distances::Dict{T, Dict{T, Int}}, valves::Dict{T, Int}, cache = Dict{Tuple{Int, T, Set{T}}, Int}()) where T
    if haskey(cache, (time, valve, mask))
        return cache[(time, valve, mask)]
    end
    maxval = 0
    for (neighbor, dist) in distances[valve]
        remtime = time - dist - 1
        if remtime > 0 && !(neighbor in mask)
            maskcopy = copy(mask)
            push!(maskcopy, neighbor)
            maxval = max(maxval, cachedfs(remtime, neighbor, maskcopy, distances, valves, cache) + (valves[neighbor] * remtime))
        end
    end
    cache[(time, valve, mask)] = maxval
    return maxval
end

function main(filename, minutes)
    valves, tunnels = parseInput(filename)
    distances = createdistance(valves, tunnels)
    return cachedfs(minutes, START, Set{String}(), distances, valves)
end

function maintwo(filename, minutes)
    valves, tunnels = parseInput(filename)
    distances = createdistance(valves, tunnels)
    positivevalves = filter(((v, f),)-> f > 0, valves) |> keys |> collect
    cache = Dict{Tuple{Int, String, Set{String}}, Int}()
    # first with increase empty and decrease full
    m = 0
    # @show m
    n = length(positivevalves)
    # n = 3
    @showprogress for i = 0:((2^n)-1)/2
        indexes = findall(el -> el == '1', UInt16(i) |> bitstring |> reverse)
        # @show indexes
        increase = Set{String}(map(i -> positivevalves[i], indexes))
        decrease = Set{String}(filter(el -> !(el in increase), positivevalves))
        # push!(increase, v)
        # delete!(decrease, v)
        m = max(m, cachedfs(minutes, START, increase, distances, valves, cache) + cachedfs(minutes, START, decrease, distances, valves, cache))
        # @show m
        # @show increase
        # @show decrease
    end
    return m
end

# @time println("easy\t", main("easy.txt", 30))
# @time println("hard\t", main("hard.txt", 30))
@time println("easy\t", maintwo("easy.txt", 26))
@time println("hard\t", maintwo("hard.txt", 26))