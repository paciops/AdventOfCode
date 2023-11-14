minMax = vect -> (minimum(vect), maximum(vect))

function createMatrix(x,y)
    return fill('.', x,y) 
end

sortRange = (a,b) -> a > b ? (b:a) : (a:b)
center = ((y, x)) -> (y, x+1)
left = ((y, x)) -> (y-1, x+1)
right = ((y, x)) -> (y+1, x+1)

ORIGIN = '+'
FREE = '.'
ROCK = '#'
SAND = 'o'

function move(map, start, limit)
    visited = Set()
    queue = [start]
    count = 0
    while length(queue) > 0
        y, x = popfirst!(queue)
        if x == limit
            continue
        end
        if (y, x) in visited
            continue
        else
            if !haskey(map, (y, x))
                map[(y, x)] = SAND
            end

            if !haskey(map, right(y, x))
                pushfirst!(queue, right(y, x))
            end
            if !haskey(map, left(y, x))
                pushfirst!(queue, left(y, x))
            end
            if !haskey(map, center(y, x))
                pushfirst!(queue, center(y, x))
            end
        end
        # if count % 1000 == 0
        #     Base.run(`clear`)
        #     printMap(map)
        # end
        count += 1
    end
    return count
end

function printMap(map)
    minX, maxX = (keys(map) .|> last) |> minMax
    minY, maxY = (keys(map) .|> first) |> minMax
    println()
    for x in minX:maxX 
        for y in minY:maxY
            if haskey(map, (y,x))
                print(map[(y,x)])
            else
                print(FREE)
            end
        end 
        println()
    end
    println()
end

function main(filename)
    map = Dict{Tuple{Int32, Int32}, Char}()
    origin = (500, 0)
    map[origin] = ORIGIN
    open(filename) do file
        for line in eachline(file)
            points = split(line, " -> ") .|> str -> (split(str, ",") .|> c -> parse(Int32, c) ) |> collect
            for i = 1:length(points)-1
                from, to = points[i], points[i+1]
                for j = sortRange(from[1],to[1])
                    for k = sortRange(from[2],to[2])
                        map[(j, k)] = ROCK
                    end
                end

            end
        end
    end
    println(move(map, origin, last((keys(map) .|> last) |> minMax)+2))
    # printMap(map)
end


@time main("easy.txt")
@time main("hard.txt")