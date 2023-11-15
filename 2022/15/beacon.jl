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

function pointWithDistance((x, y), p::Point)
    return Point(x, y, sortedDiff(x, p.x) + sortedDiff(y, p.y))
end


@enum Type sensor beacon

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

function main(filename, y)
    map = Dict{Point, Type}()
    open(filename) do file
        for line in eachline(file)
            array = filter(el -> '=' in el, split(line, " ")) .|> removepunc .|> removevar .|> parseInt
            b = Point(array[3], array[4])
            map[b] = beacon
            map[pointWithDistance((array[1], array[2]), b)] = sensor
        end
    end
    # for each sensor, check if touch row maxY
    touchy = (p::Point) -> y in p.y-p.d : p.y+p.d
    sensors = filter(el -> isSensor(el) && touchy(el), keys(map)) |> collect
    beacons = filter(isBeacon, keys(map))
    n = length(sensors)
    array = Array{Array{Point}}(undef, n)
    
    Threads.@threads for i = 1:n
        array[i] = pointswithy(sensors[i], y, beacons)
    end
    
    l = array |> Iterators.flatten |> Set |> length
    println(l)
end

@time main("easy.txt", 10)
@time main("easy.txt", 10)
@time main("hard.txt", 2000000)