module Day12

using AdventOfCode2023

function parserow((records, numbers),)
    return (String(records), AdventOfCode2023.parseint.(split(numbers, ',')))
end

function parseinput(input::String)
    rawrows = split.(split(input, '\n'), ' ')
    return map(parserow, rawrows)
end

function tostring(str)
    return map(s -> s == '0' ? '#' : '.', str)
end

Cache = Dict{Tuple{String, Array{Int}}, Int}

function calcsimilar((records, nums), cache::Cache)
    if haskey(cache, (records, nums))
        return cache[(records, nums)]
    end
    
    if isempty(nums)
        return '#' in records ? 0 : 1
    end

    if isempty(records)
        return 0
    end


    nextchar = records[1]
    nextnum = nums[1]

    dot = () -> calcsimilar((records[2:end], nums), cache)
    pound = () -> begin
        n = length(records)
        x = min(nextnum, n)
        thisgroup = replace(records[1:x], '?'=>'#')
        nextgroup = repeat('#', nextnum)

        thisgroup !== nextgroup && return 0
        n === nextnum && return length(nums) === 1 ? 1 : 0
        !(records[nextnum+1] in "?.") && return 0
        
        return calcsimilar((records[nextnum+2:end], nums[2:end]), cache)
    end
    result = 0
    if nextchar == '#'
        result = pound()
    elseif nextchar == '.'
        result = dot()
    elseif nextchar == '?'
        result = dot() + pound()
    else
        throw("Cannot parse $nextchar of string $records")
    end

    # @show records, nums, result
    cache[(records, nums)] = result
    return result
end

function ntimes((records, nums),; separator = '?', n = 5)
    nrecords = join(repeat([records], n), separator)
    nnums = repeat(nums, n)
    return (nrecords, nnums)
end

function solve(input::String = AdventOfCode2023.readinput(12))
    parsedinput = parseinput(input)
    cache = Cache()
    calcwithcache = (tuple) -> calcsimilar(tuple, cache)
    part1 = @time map(calcwithcache, parsedinput)
    part2 = @time map(calcwithcache, ntimes.(parsedinput))
    return sum(part1), sum(part2)
end

end
