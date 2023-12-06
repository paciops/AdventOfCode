module Day3

using AdventOfCode2023

GEAR = '*'

function issymbol(c::Char)
    return !isdigit(c) && c !== '.'
end

function parseinput(input::String)
    lines = split(input, '\n')
    matrix = fill(' ', length(lines), length(first(lines)))
    symbols = []
    for (i, l) in enumerate(lines)
        for (j, c) in enumerate(collect(l))
            matrix[i, j] = c
            if issymbol(c)
                push!(symbols, (i, j))
            end
        end
    end
    return matrix, symbols
end

function check(matrix::Matrix{Char}, x::Int, y::Int, dims::Tuple{Int, Int})
    return  x > 0 && x <= dims[1] && y > 0 && y <= dims[2] && isdigit(matrix[x, y])
end

function solve(input::String = AdventOfCode2023.readinput(3))
    matrix, symbols = parseinput(input)
    # for every symbol check if there is a number close
    dims = size(matrix)
    numberspositions = []
    gears = []
    for (x, y) in symbols
        if matrix[x, y] == GEAR
            push!(gears, (x, y))
        end
        for i = x-1:x+1, j = y-1:y+1
            if check(matrix, i, j, dims)
                push!(numberspositions, (i, j))
            end
        end
    end
    lesspos = (a, b) -> begin
        if a[1] === b[1]
            return isless(a[2], b[2])
        else
            return isless(a[1], b[1])
        end
    end
    visited = Set()
    s = 0
    sort!(numberspositions; lt=lesspos)
    posnummap = Dict()
    for (x, y) in numberspositions
        if !((x, y) in visited)
            # (x, y) is the closest position to the symbol
            num = ""
            j = y
            while j > 0 && isdigit(matrix[x, j])
                push!(visited, (x, j))
                num = matrix[x, j] * num
                j -= 1
            end
            j = y+1
            while j <= dims[2] && isdigit(matrix[x, j])
                push!(visited, (x, j))
                num = num * matrix[x, j]
                j += 1
            end
            n = parse(Int, num)
            s += n
            posnummap[(x, y)] = n
        end
    end
    ratio = 0
    for gear in gears
        lucky = filter(k -> abs(k[1]-gear[1]) <= 1 && abs(k[2]-gear[2]) <= 1, keys(posnummap)) |> collect
        if length(lucky) == 2
            ratio +=  map(k -> posnummap[k], lucky) |> prod
        end
    end
    return s, ratio
end

end