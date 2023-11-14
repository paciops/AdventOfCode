minMax = vect -> (minimum(vect), maximum(vect))

function createMatrix(x,y)
    return fill('.', x,y) 
end

sortRange = (a,b) -> a > b ? (b:a) : (a:b)

ORIGIN = '+'
FREE = '.'
ROCK = '#'
SAND = 'o'

getXs = map -> keys(map) |> collect .|> last  |> Set
getYs = map -> keys(map) |> collect .|> first |> Set

function nextPosition((y,x), map, limit, Xs)
    void = false
    while true
        if x > maximum(Xs)
            if x == limit
                # reached bottom
                return (y, x-1), void
            end
            for y in getYs(map)
                map[(y, x)] = FREE
            end
            push!(Xs, x)
        end
        curr = map[(y,x)]
        if curr == ORIGIN
            x+=1
        elseif curr == FREE
            x+=1
        elseif curr in [SAND, ROCK]
            if haskey(map, (y-1,x)) && map[(y-1,x)] == FREE
                return nextPosition((y-1,x), map, limit, Xs)
            elseif haskey(map, (y+1,x)) && map[(y+1,x)] == FREE
                return nextPosition((y+1,x), map, limit, Xs)
            elseif !haskey(map, (y-1,x))
                println("VOID IN LEFT ", (y-1,x))
                # add a left column
                for x in Xs
                    map[(y-1, x)] = FREE
                end
                return nextPosition((y-1,x), map, limit, Xs)
            elseif !haskey(map, (y+1,x))
                println("VOID IN RIGHT ", (y+1,x))
                # add a right column
                for x in Xs
                    map[(y+1, x)] = FREE
                end
                return nextPosition((y+1,x), map, limit, Xs)
            end
            return (y, x-1), void
        end
    end
end

function printMap(map)
    minX, maxX = (keys(map) .|> last) |> minMax
    minY, maxY = (keys(map) .|> first) |> minMax
    println()
    for x in minX:maxX 
        for y in minY:maxY
            print(map[(y,x)])
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
    minX, maxX = (keys(map) .|> last) |> minMax
    minY, maxY = (keys(map) .|> first) |> minMax
    for x = minX:maxX
        for y = minY:maxY
            key = (y,x)
            if !haskey(map, key)
                map[key]=FREE
            end
        end
    end

    # sortedKeys = (keys(map) |> keys -> sort(keys|>collect; by=x->(x[1],x[2])))
    # basic map is created
    # printMap(map)
    # now iterate untill no more sand is droppable
    count = 0
    void = false 
    while map[origin] !== SAND
        index, void = nextPosition(origin, map, maxX+2, getXs(map))
        map[index] = SAND
        if count % 1000 == 0   
            Base.run(`clear`)
            printMap(map)
        end
        count += 1
    end
    println("Count = ", count)
    # printMap(map)
    
end


main("easy.txt")
main("hard.txt")