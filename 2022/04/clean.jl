function contains(one, two)
    if one[1] <= two[1] && one[2] >= two[2]
        return true
    end
    return false
end
function partialContains(one, two)
    if contains(one, two)
        return true
    end
    if one[2] >= two[1] && one[1] <= two[2]
        return true
    end
    return false
end

function main(fileName, containsFunction)
    tot = 0
    open(fileName) do file
        for string in eachline(file)
            elfOne, elfTwo = split(string, ",") .|> x -> split(x, "-") .|> x -> parse(Int, x)
            if containsFunction(elfOne, elfTwo) || containsFunction(elfTwo, elfOne)
                tot = tot + 1
            end
        end
    end
    return tot
end

println(main("input.txt", contains))
println(main("input.txt", partialContains))