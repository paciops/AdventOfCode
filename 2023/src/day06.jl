module Day6
    
using AdventOfCode2023

function parseinput(input::String)
    time, distance = split(input, '\n')
    clean = (l) -> split(l)[2:end] .|> el -> parse(Int, el)
    return clean(time), clean(distance)
end

function solve(input::String = AdventOfCode2023.readinput(6))
    time, distance = parseinput(input)
    bigger =  ((i, t),) -> begin
        acc = 0
        for j in 0:t
            if (t-j) * j > distance[i]
               acc +=  1
            end
        end
        acc
    end
    t = parse(Int, join(time))
    d = parse(Int, join(distance))
    return prod(bigger, enumerate(time)), count(j -> (t-j) * j > d, collect(0:t))
end

end