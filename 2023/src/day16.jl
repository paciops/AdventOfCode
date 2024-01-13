module Day16

using AdventOfCode2023

Point = Complex{Int}

function nextpoint(curr::Point, dir::String, matrix::Matrix{Char})
    x, y = real(curr), imag(curr)
    cell = matrix[x, y]
    # @show x, y, cell
    if cell in ['.', '#']
        dir === "left" && return [(curr+1im, dir)]
        dir === "right" && return [(curr-1im, dir)]
        dir === "top" && return [(curr+1, dir)]
        dir === "bottom" && return [(curr-1, dir)]
    elseif cell === '|'
        if dir in ["left", "right"]
            return [(curr+1, "top"), (curr-1, "bottom")]
        else
            return [(dir === "top" ? curr+1 : curr-1, dir)]
        end
    elseif cell === '-'
        if dir in ["top", "bottom"]
            return [(curr+1im, "left"), (curr-1im, "right")]
        else
            return [(dir === "left" ? curr+1im : curr-1im, dir)]
        end
    elseif cell === '/'
        dir === "left" && return [(curr-1, "bottom")]
        dir === "right" && return [(curr+1, "top")]
        dir === "top" && return [(curr-1im, "right")]
        dir === "bottom" && return [(curr+1im, "left")]
    elseif cell === '\\'
        dir === "left" && return [(curr+1, "top")]
        dir === "right" && return [(curr-1, "bottom")]
        dir === "top" && return [(curr+1im, "left")]
        dir === "bottom" && return [(curr-1im, "right")]
    end
    throw("Cannot handle $cell at ($x, $y) with direction $dir")
end

cleanpoint = (p::Point, n::Int, m::Int) -> 0 < real(p) <= n && 0 < imag(p) <= m
cleanpoints = (n::Int, m::Int) -> (array::Array{Tuple{Point, String}}) -> filter(((p, _),)-> cleanpoint(p, n, m), array)

allaround = (p::Point) -> [p+1, p-1, p+1im, p-1im]

printmatrix = (matrix, visited) -> begin
    n, m = size(matrix)
    for i in 1:n
        for j in 1:m
            cell = matrix[i, j]
            comp = Complex(i, j)
            print(comp in visited ? '#' : cell)
        end
        println()
    end
end

function countenergized(clean::Function, startpoint::Point, direction::String, matrix::Matrix{Char})
    queue = [(startpoint, direction)]
    visited = Set{Tuple{Point, String}}()
    pointSet = Set{Point}()
    while !isempty(queue)
        curr, dir = popfirst!(queue)
        push!(visited, (curr, dir))
        push!(pointSet, curr)
        points = filter(t -> !(t in visited), clean(nextpoint(curr, dir, matrix)))
        queue = [points..., queue...]
    end
    # printmatrix(matrix, pointSet)
    # println()
    return length(pointSet)
end

function generatestartingpoints(n, m)
    return [[(Complex(1, p), "top") for p in 1:m],
        [(Complex(n, p), "bottom") for p in 1:m],
        [(Complex(p, 1), "left") for p in 1:n],
        [(Complex(p, m), "right") for p in 1:n]] |> Iterators.flatten
end

function solve(input::String = AdventOfCode2023.readinput(16))
    matrix = split(strip(input), '\n') |> stack |> permutedims
    n, m = size(matrix)
    clean = cleanpoints(n, m)
    allresults = map(((p,d),) -> countenergized(clean, p,d, matrix), generatestartingpoints(n,m))
    return countenergized(clean, 1+1im, "left", matrix), maximum(allresults)
end
    
end