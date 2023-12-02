module Day1

using AdventOfCode2023

wordmap = ["one" => "1", "two" => "2", "three" => "3",
    "four" => "4", "five" => "5", "six" => "6", "seven" => "7",
    "eight" => "8", "nine" => "9"]

wordkeys = map(first, wordmap)

function solve(input::String = AdventOfCode2023.readinput(1); partTwo = false)
    acc = 0
    if partTwo
        specialmap = Vector{Pair{String, String}}()
        for a in wordkeys
            for b in wordkeys
                if a[end] == b[1]
                    push!(specialmap, (a) * (b[2:end]) => "$(findfirst(el -> first(el) == a, wordmap))$(findfirst(el -> first(el) == b, wordmap))")
                end
            end
        end
    end
    for l in split(input, '\n') .|> String
        isempty(l) && continue
        if partTwo
            l = Base.replace(l, specialmap...)
            l = Base.replace(l, wordmap...)
        end
        acc += filter(isdigit, l) |> list -> parse(Int, list[1] * list[end])
    end
    return acc
end

end