module AdventOfCode2023

# include all days
function includedays()
    folder = joinpath(@__DIR__)
    for file in filter(el -> startswith(el, "day"), readdir(folder))
        # println("including $(joinpath(folder, file))")
        include(joinpath(folder, file))
    end
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