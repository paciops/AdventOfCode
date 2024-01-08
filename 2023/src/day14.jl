module Day14

using AdventOfCode2023, ProgressMeter


function parseinput(input::String)
    return filter(!isempty, split(input, '\n')) |> stack |> permutedims
end

roundedrock = (value) -> value === 'O'
emptyspace = (value) -> value === '.'

function move!(matrix::Matrix{T}) where T
    n, m = size(matrix)
    for col in 1:m
        # println("Column $col")
        for row in 1:n
            if emptyspace(matrix[row, col])
                # swap '.' for the first 'O'
                index = findfirst(roundedrock, matrix[row+1:end, col])
                if !isnothing(index)
                    index += row
                    # println("Found a O at row $(row+index), swapping with . at $row")
                    if '#' in matrix[row:index, col]
                        # println("But there is # in the middle")
                    else
                        matrix[row, col] = 'O'
                        matrix[index, col] = '.'
                    end
                end
            end
        end
    end
    matrix
end

rotateclockwise = (m) -> reverse(permutedims(m), dims=2)
calc = (m) -> sum(((i, row),) -> count(roundedrock, row) * i, eachrow(m) |> reverse |> enumerate)

function makenmoves!(matrix::Matrix{Char}, n::Int)
    for _ in 1:n
        matrix = move!(matrix)
        matrix = rotateclockwise(matrix)
    end
    return matrix
end

function solve(input::String = AdventOfCode2023.readinput(14))
    matrix = parseinput(input)
    part1 = calc(move!(copy(matrix)))
    cache = Dict{Matrix{Char}, Int}()
    n = 1000000000
    i = 1
    found = false
    while i <= n && !found
        matrix = makenmoves!(matrix, 4)
        if haskey(cache, matrix)
            found = true
        else
            cache[copy(matrix)] = i
            i += 1
        end
    end
    t = cache[matrix]
    delta = i - t
    x = (n - t) % delta
    matrix = makenmoves!(matrix, 4 * x)
    return part1, calc(matrix)
end

end