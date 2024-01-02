module Day12

using AdventOfCode2023

using Combinatorics, ProgressMeter, Folds

function parserow((records, numbers),)
    return (records,AdventOfCode2023.parseint.(split(numbers, ',')))
end

function parseinput(input::String)
    rawrows =  split.(split(input, '\n'), ' ')
    return map(parserow, rawrows)
end

function tostring(str)
    return map(s -> s == '0' ? '#' : '.', str)
end

function countsimilar(counter, occurrences, records, finalresult)
    @show records, finalresult
    return reduce(
        (acc, s) -> begin
        @show s
        similar = only.(split(string(records), ""))
        for (i, x) in enumerate(s)
            similar[occurrences[i]] = x
        end
        similar = join(filter(!isempty, split(join(similar), '.')), '.')
        acc += similar .== finalresult ? 1 : 0 
        return acc
        end,
        [tostring(bitstring(x)[end-(counter-1):end]) for x in 0:2^counter-1];
        init=0
    )
end

function solve(input::String = AdventOfCode2023.readinput(12))
    tot = Folds.map(
        ((records, nums),) -> begin
            finalresult = join([repeat('#', n) for n in nums], '.')
            occurrences = findall(e -> e == '?', records)
            c = length(occurrences)
            countsimilar(c, occurrences, records, finalresult)
        end,
        [parseinput(input)[1]]
    )
    part2 = 0
    return sum(tot), part2
end

end
