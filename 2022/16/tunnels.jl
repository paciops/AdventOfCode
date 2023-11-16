using DataStructures

function parseValve(data::Vector{String})
    valves = findfirst(el -> el == "valves", data)
    if valves == nothing
        valves = findfirst(el -> el == "valve", data)
    end
    return replace.(data[valves+1:end], "," => "")
end

struct Node
    flow::Int
    valves::Array{String}
end

function parseInput(filename::String)
    map = Dict{String, Node}()
    start = nothing
    open(filename) do file
        for line in eachline(file)
            data = String.(split(line, " "))
            name = data[2]
            start = isnothing(start) ? name : start
            flow = parse(Int, replace(data[5], ";"=>" ", "rate="=>" "))
            valves = parseValve(data)
            node = Node(flow, valves)
            map[name] = node
        end
    end
    return map, start
end

function sortfn(a::Tuple{String, Tuple{Int, Int}}, b::Tuple{String, Tuple{Int, Int}})
    if a[2][1] == b[2][1]
        return isless(a[2][2], b[2][2])
    else
        return !isless(a[2][1], b[2][1])
    end
end

function nextnode(key::String, map::Dict{String, Node}, open::Set{String})
    flows = Dict{String, Tuple{Int, Int}}(key => (0, 0))
    queue = [key]
    visited = Set()
    bestflow = -1
    index = ""
    while !isempty(queue)
        current_node = popfirst!(queue)
        _, current_distance = flows[current_node]
        

        push!(visited, current_node)

        for k in filter(el -> !(el in visited), map[current_node].valves)
            f = map[k].flow - current_distance + 1
            if k in open
                f = current_distance + 1
            end
            flows[k] = f, current_distance + 1
            if f > bestflow
                bestflow = f
                index = k
            end
            push!(queue, k)
        end
    end
    return index
end

function main(filename, seconds = 30)
    map, next = parseInput(filename)
    # println.(zip(keys(map), values(map)))
    open = Set{String}()
    total = 0
    sum = 0
    for i = 1:seconds
        println("== Minute $(i) ==")
        msg = length(open) > 0 ? "Valves $(join(open, ", ")) are open" : "No valves are open"
        msg *= sum > 0 ? ", releasing $(sum) pressure." : ""
        println(msg)
        key = next
        curr = map[key]
        if curr.flow == 0 || key in open
            next = nextnode(key, map, open)
            println("You move to $(next)")
        else
            println("You open valve $(key)")
            sum += curr.flow
            # todo change 30 to seconds
            total += curr.flow * (30-i)
            next = key
            push!(open, key)
        end
        println("")
    end
    return total
end

println(main("easy.txt", 30))
# println(main("hard.txt", 30))