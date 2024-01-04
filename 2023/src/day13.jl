module Day13

using AdventOfCode2023


function parseinput(input::String)
    return map(line -> split(line, '\n') |> stack |> permutedims, split(input, "\n\n"))
end

rowdiff = (prev, curr) -> reduce((a,e) -> (e !== 0) + a, prev - curr ; init=0)

function verifycenter(matrix, i, j, n, smudge::Bool)
    i -= 1
    j += 1
    while i > 0 && j <= n
        Δrow = rowdiff(matrix[:, i], matrix[:, j])
        if smudge && Δrow === 1
            smudge = false
        elseif Δrow !== 0
            return false
        end
        i -= 1
        j += 1
    end
    return !smudge
end

function findcenter(matrix::Matrix{Char}, smudge::Bool)
    _, m = size(matrix)
    i = 2
    while i <= m
        Δrow = rowdiff(matrix[:, i-1], matrix[:, i])
        Δrow === 0 && verifycenter(matrix, i-1, i, m, smudge) && return i-1, i
        Δrow === 1 && smudge && verifycenter(matrix, i-1, i, m, false) && return i-1, i
        i += 1
    end
    return nothing
end

printmatrix = (matrix) -> println.(eachrow(matrix))

function findverticalorhorizontal(matrix::Matrix{Char}; smudge=false)
    # search in vertical, if nothing search in horizontal
    center = findcenter(matrix, smudge)
    if !isnothing(center)
        return center[1]
    end
    center = findcenter(permutedims(matrix), smudge)
    if isnothing(center)
        return 0
    end
    return center[1] * 100
end

function solve(input::String = AdventOfCode2023.readinput(13))
    matrices = parseinput(input)
    return sum(findverticalorhorizontal.(matrices)), sum(findverticalorhorizontal.(matrices; smudge=true))
end

end