minMax = vect -> (minimum(vect), maximum(vect))

function createMatrix(x,y)
    return fill('.', x,y) 
end

sortRange = (a,b) -> a > b ? (b:a) : (a:b)

ORIGIN = '+'
FREE = '.'
ROCK = '#'
SAND = 'o'

function nextPosition((y,x), map)
    void = false
    while true
        curr = map[(y,x)]
        if curr == ORIGIN
            x+=1
        elseif curr == FREE
            x+=1
        elseif curr in [SAND, ROCK]
            if haskey(map, (y-1,x)) && map[(y-1,x)] == FREE
                return nextPosition((y-1,x), map)
            elseif haskey(map, (y+1,x)) && map[(y+1,x)] == FREE
                return nextPosition((y+1,x), map)
            end
            if !haskey(map, (y-1,x))
                println("VOID IN LEFT ", (y-1,x))
                void = true
            elseif !haskey(map, (y+1,x))
                println("VOID IN RIGHT ", (y+1,x))
                void = true
            end
            return (y, x-1), void
        end
    end
end

function printMap(map, (minX, maxX), (minY, maxY))
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
    minX, maxX = (keys(map) .|> el -> el[2]) |> minMax
    minY, maxY = (keys(map) .|> el -> el[1]) |> minMax
    _printMap = () -> printMap(map, (minX, maxX),(minY, maxY))
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
    # now iterate untill no more sand is droppable
    count = 0
    void = false 
    while map[(origin[1], origin[2]+1)] == FREE && !void
        index, void = nextPosition(origin, map)
        map[index] = SAND
        # _printMap()
        count += 1
    end
    println("Count = ", count-1)
    _printMap()
    
end


main("easy.txt")
main("hard.txt")