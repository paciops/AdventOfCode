lowerOffset = 'a'
upperOffset = 'A'

function char2Int(c)
    if islowercase(c)
        return c - lowerOffset + 1
    else
        return c - upperOffset + 27
    end    
end

function main(fileName)
    tot = 0
    newTot = 0
    index = 1
    prev = ("", "")
    open(fileName) do file
        for string in eachline(file)
            half = Int(length(string)/2)
            firstSet = Set(string[1:half])
            secondSet = Set(string[half+1:end])
            i = intersect(firstSet, secondSet) |> first
            c = char2Int(i)
            tot = tot + c
            if index < 3
                prev = Base.setindex(prev, string, index)
                index = index + 1
            else
                newTot = newTot + char2Int(intersect(prev[1], prev[2], string) |> first)
                index = 1
            end
        end
    end
    return tot, newTot
end

println(main("input.txt"))