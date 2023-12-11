module Day10

using ProgressMeter

using AdventOfCode2023

GROUND = '.'
START = 'S'

function getpipefun(c::Char)
    if c == 'J'
        return (a::Complex{Int}, b::Complex{Int}) -> a - b == 1 || a - b == 1im
    end
    if c == 'L'
        return (a::Complex{Int}, b::Complex{Int}) -> a - b == 1 || a - b == -1im
    end
    if c == '7'
        return (a::Complex{Int}, b::Complex{Int}) -> a - b == -1 || a - b == 1im
    end
    if c == 'F'
        return (a::Complex{Int}, b::Complex{Int}) -> a - b == -1 || a - b == -1im
    end
    if c == '|'
        return (a::Complex{Int}, b::Complex{Int}) -> a - b |> res -> abs(real(res)) == 1 && imag(res) == 0
    end
    if c == '-'
        return (a::Complex{Int}, b::Complex{Int}) -> a - b |> res -> real(res) == 0 && abs(imag(res)) == 1
    end
    if c == START
        return true
    end
    if c == GROUND
        return (a::Complex{Int}...) -> false
    end
    throw("Cannot find $c")
end

function parseinput(input::String)
    rows = split(input, '\n')
    n = length(rows)
    m = length(first(rows))
    pairs = map(((i, j),) -> Complex(i,j)=> getpipefun(rows[i][j]), Iterators.product(1:n, 1:m))
    return Dict(pairs), n, m
end

function getneighbors(curr::Complex{Int}, (n,m)::Tuple{Int, Int})
    return [
        curr - 1im, # NORD
        curr + 1im, # SOUTH
        curr - 1,   # EAST
        curr + 1,   # WEST
    ]
end

function bfs(start::Complex{Int}, data::Dict{Complex{Int}, Any}, n::Int, m::Int)
    queue = [start]
    visited = Set()
    distances = Dict(start => 0)
    while !isempty(queue)
        curr = popfirst!(queue)
        delta = distances[curr] + 1
        for i in filter(k -> haskey(data, k) && !(k in visited) && data[k](k, curr), getneighbors(curr, (n, m)))
            push!(queue, i)
            distances[i] = delta
        end
        push!(visited, curr)
    end
    return distances, visited
end

function solve(input::String = AdventOfCode2023.readinput(10))
    dict, n, m = parseinput(input)
    startposition = findfirst(e -> e == true, dict)
    distances, visited = bfs(startposition, dict, n, m)
    @show setdiff(keys(dict), visited)
    return maximum(last, distances)
end
    
end