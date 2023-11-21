using DataStructures

function parseValve(data::Vector{String})
    valves = findfirst(el -> el == "valves", data)
    if valves == nothing
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

function findbest(map, distances, key, opened)
    best = 0.0
    index = nothing
    for (k, dist) in distances
        if !(k in opened)
            valve = map[k]
            d = distances[key][k]
            d = d == 0 ? 1 : d
            if valve.flow / d > best
                best = valve.flow / d
                index = k
            end
        end
    end
    return index
end

function main(filename, seconds = 30, verbose = false)
    map, next = parseInput(filename)
    # println.(zip(keys(map), values(map)))
    n = length(keys(map))
    setofvalues = (values(map) .|> val -> val.flow)
    best = setofvalues |> sum
    distances = Dict{String, Dict{String, Int}}()
    for k in keys(map) |> collect |> sort
        # println(k, " => ", map[k])
        distances[k] = bfs(map, k)
    end
    # @show distances
    opened = []
    s = 0
    tot = 0
    i = 1
    operation = ""
    steps = 0
    while i <= seconds && !isnothing(next)
        curr = next
        next = findbest(map, distances, next, opened)
        if !isnothing(next)
            # now should i open or should i change?
            # i will change
            # 1 second to move from curr to next
            # 1 second to open
            # but i could need more than 1 second to move
            # i spend a second for each move from node to node
            println("== Minute $(i) ==")
            msg = length(opened) == 0 ? "No valves are open." : "Valve $(join(opened, ", ")) are open"
            msg *= s == 0 ? "" : ", releasing $(s) pressure" 
            println(msg)
            if operation == ""
                println("You move to valve $(next).")
                # but how long is the distance?
                delta = distances[curr][next]
                # println("That is at distance $(delta)")
                # distance is stored in delta
                operation = "open"
                steps = delta
                curr = next
            elseif operation == "open"
                if steps == 1
                    println("You open valve $(curr).")
                    push!(opened, curr)
                    tot += map[next].flow * (seconds - (i+1))
                    s += map[next].flow
                    operation = ""
                else
                    steps -= 1
                end
            end
            # push!(opened, )

            
            
            
            # println("distance from $(curr) to $(next) is $(delta)")
            # println("delta $(delta)")
            # seconds -= delta
            # println("flow * seconds  = $(map[next].flow) * $(seconds)")
            # println("best node from $(curr) is $(next)")
        end
        println()
        i +=  1
    end

    return s, tot
end

@time println(main("easy.txt", 30))
# @time println(main("hard.txt", 30))