module Day11

using  AdventOfCode2023
    
function parseinput(input::String)
    (split(input, '\n') .|> row -> only.(split(row, ""))) |> stack |> permutedims
end

function solve(input::String = AdventOfCode2023.readinput(11); expansion = 2)
    matrix =  parseinput(input)
    n, m = size(matrix)
    galaxies = filter(((i, j),) -> matrix[i, j] == '#', collect(Iterators.product(1:n, 1:m)))
    
    rows = first.(filter(((i, row),) -> all(row .== '.'), matrix |> eachrow |> enumerate |> collect))
    cols = first.(filter(((i, col),) -> all(col .== '.'), matrix |> eachcol |> enumerate |> collect))
    
    calculatedelta = (acc, (onegalaxy, anothergalaxy),) -> begin
        xmin, xmax = minmax(onegalaxy[1], anothergalaxy[1])
        ymin, ymax = minmax(onegalaxy[2], anothergalaxy[2])
        xdelta = abs(onegalaxy[1] - anothergalaxy[1]) + (expansion-1) * (intersect(xmin:xmax, rows) |> length) 
        ydelta = abs(onegalaxy[2] - anothergalaxy[2]) + (expansion-1) * (intersect(ymin:ymax, cols) |> length)
        return acc + xdelta + ydelta
    end

    g = length(galaxies)
    pairs = [(galaxies[i], galaxies[j]) for i = 1:g for j = i+1:g]
    return reduce(calculatedelta, pairs; init=0)
end

end