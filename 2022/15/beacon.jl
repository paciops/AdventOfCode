using ProgressMeter

struct Point
    x::Int32
    y::Int32
    d::Union{Int32, Nothing}
    function Point(x, y, d = nothing)
        new(x, y, d)
    end
end

isBeacon = (p::Point) -> isnothing(p.d)
isSensor = (p::Point) -> !isBeacon(p)
sortedDiff = (a, b) -> a > b ? a-b : b-a 
minandmax = (vect) -> (minimum(vect), maximum(vect))

function pointWithDistance((x, y), p::Point)
    return Point(x, y, sortedDiff(x, p.x) + sortedDiff(y, p.y))
end

removepunc = vect -> (replace(vect, ","=>"", ":"=> ""))
removevar = vect -> (replace(vect, "x="=>"", "y="=> ""))
parseInt = str -> parse(Int32, str)

function pointswithy(p::Point, y, beacons::Set{Point})
    delta = 0
    points = []
    if p.y < y 
        delta = y - p.y
    else
        delta = p.y - y 
    end
    delta = p.d - delta
    for x = p.x-delta : p.x+delta
        newpoint = Point(x, y)
        if !(newpoint in beacons)
            push!(points, newpoint)
        end
    end
    return points
end

function parseFile(filename)
    beacons = Set{Point}()
    sensors = Set{Point}()
    open(filename) do file
        for line in eachline(file)
            array = filter(el -> '=' in el, split(line, " ")) .|> removepunc .|> removevar .|> parseInt
            b = Point(array[3], array[4])
            push!(beacons, b)
            push!(sensors, pointWithDistance((array[1], array[2]), b))
        end
    end
    return beacons, collect(sensors)
end

function main(filename, y)
    # for each sensor, check if touch row maxY
    touchy = (p::Point) -> y in p.y-p.d : p.y+p.d
    beacons, sensors  = parseFile(filename)
    n = length(sensors)
    array = Array{Array{Point}}(undef, n)  

    Threads.@threads for i = 1:n
        array[i] = pointswithy(sensors[i], y, beacons)
    end
    
    l = array |> Iterators.flatten |> Set |> length
    println(l)
end

function ispointclose(first::Point, second::Point)
    return sortedDiff(first.x, second.x) + sortedDiff(first.y, second.y) <= first.d
end

function pointsrange(points::Array{Point})
    xmin, xmax = (points .|> p -> p.x) |> minandmax
    ymin, ymax = (points .|> p -> p.y) |> minandmax
    return xmin:xmax, ymin:ymax
end

LIMIT = 4000000

function maintwo(filename)
    beacons, sensors  = parseFile(filename)
    n = length(sensors)
    println("I have $(n) sensors")
    xs, ys = pointsrange(sensors)
    xlength, ylength = last(xs)-first(xs), last(ys)-first(ys)
    # compute all the points outside a perimeter
    points = Set{Point}()
    @showprogress for i = 1:n
        s = sensors[i]
        d = s.d
        for i = -1:d+1
            y , x = s.y - d + i , s.x + i
            if y in ys && x in xs
                push!(points, Point(x,y))
            end
        end
        for i = 0:d+1
            y , x = s.y + i , s.x + d + 1 - i
            if y in ys && x in xs
                push!(points, Point(x,y))
            end
        end
        for i = 0:d+1
            y , x = s.y + d + 1 - i, s.x  - i
            if y in ys && x in xs
                push!(points, Point(x,y))
            end
        end
        for i = 0:d+1
            y , x = s.y - i, s.x - i + d + 1
            if y in ys && x in xs
                push!(points, Point(x,y))
            end
        end
    end
    println("Possible points $(length(points)) in $(xlength*ylength) possible points")
    @showprogress for p in reverse(points |> collect)
        if all(s -> !ispointclose(s, p), sensors)
            return p.x * 4000000 + p.y
        end
    end
    return nothing
end


# @time main("easy.txt", 10)
# @time main("hard.txt", 2000000)

@time println("easy -> ", maintwo("easy.txt"))
@time println("hard -> ", maintwo("hard.txt"))
