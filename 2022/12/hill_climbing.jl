OFFSET = Int('a') - 1

DEBUG=false

function to_char(substring)
    c = only(substring)
    if c == 'S'
        return 0
    end
    if c == 'E'
        return Int('z') - OFFSET + 1
    end
    return Int(c) - OFFSET
end

create_matrix(filename) = (filename |> readlines .|> x -> (split(x, "") .|> to_char)) |> x -> permutedims(hcat(x...))

struct Position
    x::Int
    y::Int
end

function find_index(matrix, el)
    x, y = size(matrix)
    for row in 1:x
        for col in 1:y
            if matrix[row, col] == el
                return Position(row, col)
            end
        end
    end
    throw("$el element not found")
end

function print_distances(dim, distances)
    distances_matrix = ones(dim) .* -1
    for key in keys(distances)
        distances_matrix[key.x, key.y] = Int(distances[key])
    end
    #distances_matrix[dest.x, dest.y] = -2.0
    distances_matrix |> eachrow .|> println
end

function degree(graph, friends, source, dest)
    distances = Dict(source => 0)
    queue = [source]

    # until the queue is empty, get elements and inspect their neighbours
    while !isempty(queue)
        # shift the first element off the queue
        current = popfirst!(queue)

        # base case: if this is the destination, just return the distance
        if current == dest
            #print_distances(size(friends), distances)
            return distances[dest]
        end

        # go through all the neighbours
        for neighbour in graph[current]
            # if their distance is not already known...
            if !haskey(distances, neighbour)
                # then set the distance
                distances[neighbour] = distances[current] + 1

                # and put into queue for later inspection
                push!(queue, neighbour)
            end
        end
    end
    #DEBUG && sort(keys(distances)) .|> key -> println(key, " -> ", distances[key])

 #   print_distances(size(friends), distances)
#    keys(distances) .|> x -> println(x, " -> ", distances[x])

    # we could not find a valid path
    error("$source and $dest are not connected.")
end

function find_close(matrix, center::Position)
    # return the list of positions close to point
    n, m = size(matrix)
    result = Vector{Position}()
    points_around = [
        # top
        Position(center.x-1, center.y),
        # bottom
        Position(center.x+1, center.y),
        # left
        Position(center.x, center.y-1),
        # right
        Position(center.x, center.y+1),
    ]

    only_valid(pos::Position) = pos.x >= 1 && pos.x <= n && pos.y >= 1 && pos.y <= m
    
    for current in filter(only_valid, points_around)
        if abs(matrix[current.x,current.y] - matrix[center.x, center.y]) < 2
            push!(result, current)
        end    
    end
    
    DEBUG && println("Friends of $center are $result\n")

    return result
end

using DataStructures

function dijkstra(graph, source::T, dest::T) where T
    n = length(graph)
    #dist = fill(Inf, n)
    dist = Dict{T, Float64}()
    for k in keys(graph)
        dist[k] = Inf
    end
    dist[source] = 0
    q = PriorityQueue{T, Float64}()
    enqueue!(q, source, 0.0)
    while !isempty(q)
        u = dequeue!(q)
        d = dist[u]
        if u == dest
            return dist[dest]
        end
        if d > dist[u]
            continue
        end
        for v in graph[u]
            alt = dist[u] + 1
            if alt < dist[v]
                dist[v] = alt
                enqueue!(q, v, alt)
            end
        end
    end
    error("no path from $source to $dest")
end

function main(filename)
    m = create_matrix(filename)
    x, y = size(m)
    distances = Dict{Position, Vector{Position}}()
    for i in 1:x
        for j in 1:y
            p = Position(i, j)
            friends = find_close(m, p)
            distances[p] = friends
        end
    end
    source = find_index(m, to_char("S"))
    dest   = find_index(m, to_char("E"))
    return degree(distances, m, source, dest)
    #@time dijkstra(distances, source, dest)
end

for arg in ARGS
    res = main(arg) 
    println(arg, " -> ", res)
end