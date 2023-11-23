using DataStructures

function parseValve(data::Vector{String})
    valves = findfirst(el -> el == "valves", data)
    if isnothing(valves)
        valves = findfirst(el -> el == "valve", data)
    end
    return replace.(data[valves+1:end], "," => "")
end

struct Node{T}
    flow::Int
    valves::Array{T}
end

struct Graph{T}

end

NodeMap{T} = Dict{String, Node{T}} where T

function parseInput(filename::String)
    map = NodeMap{String}()
    start = nothing
    open(filename) do file
        for line in eachline(file)
            data = String.(split(line, " "))
            name = data[2]
            start = isnothing(start) ? name : start
            flow = parse(Int, replace(data[5], ";"=>" ", "rate="=>" "))
            valves = parseValve(data)
            node = Node{String}(flow, valves)
            map[name] = node
        end
    end
    return map, start
end

function bfs(map::NodeMap{T}, start::T) where T
    visited = Set{T}()
    queue = Vector([start])
    distances = Dict{T, Int}(start => 0)
    while !isempty(queue)
        curr = popfirst!(queue)
        distance = distances[curr]+1
        for k in map[curr].valves
            if !haskey(distances, k)
                distances[k] = distance
                push!(queue, k)
            end
        end
    end
    return distances
end

function findbest(map, distances, key, opened, avoid)
    best = 0.0
    index = nothing
    for (k, dist) in distances
        if !(k in opened) && !(k in avoid)
            valve = map[k]
            d = dist[key]
            d = d == 0 ? 1 : d
            if valve.flow / d > best
                best = valve.flow / d
                index = k
            end
        end
    end
    return index
end

function randomwalk(map, distances, next, n)
    opened = Set()
    s = 0
    order = []
    while n > 0
        push!(order, next)
        node = map[next]
        if node.flow > 0 && !(next in opened)
            s += node.flow
            push!(opened, next)
        end
        next = rand(node.valves)
        n -= 1
    end
    return s, order
end

function elementsat(paths::Vector{Vector{T}}, pos::Int) where T
    if length(paths) == 0 || length(paths[1]) < pos
        return Set{T}()
    end
    return Set(paths .|> el -> el[pos])
end

function findpath(map, distances, minutes, next, otherpaths::Vector{Vector{String}})
    opened = Set{String}()
    visited = String[]
    i = 1
    s = 0
    tot = 0
    while !isnothing(next)
        push!(visited, next)
        node = map[next]
        if node.flow > 0 && !(next in opened)
            push!(opened, next)
            s += node.flow
            tot += node.flow * (minutes-i)
            println("Minute $(i) node $(next) $(node.flow) * $(minutes-i)")
        end
        prev = next
        avoid = elementsat(otherpaths, length(visited)+1)
        println("Keys to avoid $(avoid)")
        next = findbest(map, distances, next, opened, avoid)
        if !isnothing(next)
            i += distances[prev][next] + 1
        end
    end    
    return visited, s, tot
end

function main(filename, minutes = 30, verbose = false)

    @assert elementsat([[1]],1) == Set([1]) "Result is $(elementsat([[1]],1)) instead of $(Set([1]))"
    @assert elementsat([[1,3,4,5], [2,3,4,5]],1) == Set([1,2]) "Result is $(elementsat([[1]],1)) instead of $(Set([1]))"


    map, next = parseInput(filename)
    # println.(zip(keys(map), values(map)))
    n = length(keys(map))
    distances = Dict{String, Dict{String, Int}}()
    for k in keys(map) |> collect |> sort
        # println(k, " => ", map[k])
        distances[k] = bfs(map, k)
    end
    paths = Vector{Vector{String}}()
    bests = 0
    besttot = 0
    for _ = 1:10
        path, s, tot = findpath(map, distances, minutes, next, paths)
        push!(paths, path)
        if tot > besttot
            besttot = tot
            bests = s
        end
        println()
    end
    println(path)
    return bests, besttot
end

@time println(main("easy.txt", 30))
# @time println(main("hard.txt", 30))