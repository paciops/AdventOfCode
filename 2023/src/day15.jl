module Day15

using AdventOfCode2023

function solve(input::String = AdventOfCode2023.readinput(15))
    words = split(strip(input), ',')
    # part one
    hashchar = (acc, c) -> ((Int(c) + acc) * 17) % 256
    hashword = (acc, word) ->  acc + reduce(hashchar, word; init = 0)

    # part two
    hashmap = Dict{Int, Vector{Tuple{String, Int}}}()

    for word in words
        if '=' in word
            raw = split(word, '=')
            key = raw[1]
            index = hashword(0, key)
            lens = AdventOfCode2023.parseint(raw[2])
            if haskey(hashmap, index)
                i = findfirst(((k, v),) -> k == key, hashmap[index])
                if isnothing(i)
                    push!(hashmap[index], (key, lens))
                else
                    hashmap[index][i] = (key, lens)
                end
            else
                hashmap[index] = Vector([(key, lens)])
            end
        elseif '-' in word
            key = first(split(word, '-'))
            index = hashword(0, key)
            if haskey(hashmap, index)
                i = findfirst(((k, v),) -> k == key, hashmap[index])
                if !isnothing(i)
                    deleteat!(hashmap[index], i)
                    if isempty(hashmap[index])
                        delete!(hashmap, index)
                    end
                end
            end
        else
            throw("= or - not found in $word")
        end
    end
    sumovervalues = (k, v) -> reduce((c, (i, (_, lens))) -> c + (i * (k+1) * lens), enumerate(v); init = 0)
    sumoverkeys = (acc, (k, v),) -> acc + sumovervalues(k, v)
    return reduce(hashword, words; init = 0), reduce(sumoverkeys, hashmap; init = 0)
end

end