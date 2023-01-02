function calories(fileName)
    array = [0]
    index = 1
    open(fileName) do file
        for ln in eachline(file)
            if(length(ln) > 0)
                # current elf += ln
                array[index] = array[index] +  parse(Int64, ln)
            else
                # next elf
                push!(array, 0)
                index = index + 1
            end
        end
    end
    sort!(array)
    return (last(array), array[end] + array[end-1] + array[end-2])
end
best, top3 = calories("input.txt")
println("best = $best, top3 = $top3")