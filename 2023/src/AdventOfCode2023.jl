module AdventOfCode2023

# include all days
for file in filter(el -> startswith(el, "day"), readdir(joinpath(@__DIR__)))
    println("including $(file)")
    include(file)
end

function readinput(path::String)
    s = open(path, "r") do file
        read(file, String)
    end
    return s
end

function readinput(day::Int)
    path = abspath(joinpath(@__DIR__, "..", "data", "input$(day).txt"))
    return readinput(path)
end

end # end module