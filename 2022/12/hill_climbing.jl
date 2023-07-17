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

function find_all(matrix, el)
    x, y = size(matrix)
    positions = Vector{Position}()
    for row in 1:x
        for col in 1:y
            if matrix[row, col] == el
                push!(positions, Position(row, col))
            end
        end
    end
    return positions
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
        if matrix[current.x,current.y] - matrix[center.x, center.y] <= 1
            push!(result, current)
        end    
    end
    
    DEBUG && println("Friends of $center are $result\n")

    return result
end

function bfs(distances::Dict{Position, Vector{Position}}, root::Position, dest::Position)
    queue = Vector{Position}()
    visited = Vector{Position}()
    dist = Dict{Position,Int}()
    
    push!(queue, root)
    push!(visited, root)
    dist[root] = 0

    while !isempty(queue)
        curr = popfirst!(queue)
        #println("curr = ", curr)
        for point in distances[curr]
            # if point is not visited
            if !(point in visited)
                push!(visited, point)
                push!(queue, point)
                dist[point] = dist[curr] + 1    
            end
        end
    end
    if dest in keys(dist)
        return dist[dest]
    end
    # m = maximum(values(dist))
    # println("max = ", m)
    # println(filter(x -> x[2] == m , dist))
    return typemax(Int)
end

function main(filename)
    mat = create_matrix(filename)
    x, y = size(mat)
    distances = Dict{Position, Vector{Position}}()
    for i in 1:x
        for j in 1:y
            p = Position(i, j)
            friends = find_close(mat, p)
            distances[p] = friends
        end
    end
    paths = []
    source = find_index(mat, to_char("S"))
    mat[source.x, source.y] = 1
    dest   = find_index(mat, to_char("E"))
    mat[dest.x, dest.y] = 26

    # find all 'a' in the matrix
    for pos in find_all(mat, 1)
        push!(paths, bfs(distances, pos, dest))
    end

    return minimum(paths)
end

for arg in ARGS
    @time res = main(arg) 
    println(arg, " -> ", res)
end