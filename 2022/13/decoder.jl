using Match

function parseline(original::String)
    return eval(Meta.parse(original))
end

makespace = n -> '\t' ^ n

function compare(left, right, padding = 1)
    leftsize = length(left)
    rightsize = length(right)
    tot = max(leftsize, rightsize)
    for i in 1:tot
        if i > leftsize
            println(makespace(padding),"- Left side ran out of items, so inputs are in the right order")
            return true
        end
        if i > rightsize
            println(makespace(padding),"- Right side ran out of items, so inputs are not in the right order")
            return false
        end

        println(makespace(padding), "- Compare $(left[i]) vs $(right[i])")

        @match (left[i], right[i]) begin
            (n::Int, m::Int) => begin
                if n < m
                    println(makespace(padding+1), "- Left side is smaller, so inputs are in the right order")
                    return true   
                elseif n > m
                    println(makespace(padding+1), "- Right side is smaller, so inputs are not in the right order")
                    return false
                end
            end
            (n::Vector, m::Vector) => begin
                res = compare(n, m, padding + 1)
                res !== nothing && return res
            end
            (n::Vector, m::Int) => begin
                println(makespace(padding+1),"- Mixed types; convert right to $([m]) and retry comparison")
                res = compare(n, [m], padding + 1)
                res !== nothing && return res
            end
            (n::Int, m::Vector) => begin
                println(makespace(padding+1),"- Mixed types; convert left to $([n]) and retry comparison")
                res = compare([n], m, padding + 1)
                res !== nothing && return res
            end
            _ => throw("Type not matched")
        end
    end

    return nothing
end

function mysort(left, right)
    leftsize = length(left)
    rightsize = length(right)
    tot = max(leftsize, rightsize)
    for i in 1:tot
        i > leftsize && return true
        i > rightsize && return false

        @match (left[i], right[i]) begin
            (x::Int, y::Int) => begin
                x < y && return true
                x > y && return false
            end
            (x::Vector, y::Vector) => begin
                result = mysort(x, y)
                result !== nothing && return result
            end
            (x::Vector, y::Int) => begin
                result = mysort(x, [y])
                result !== nothing && return result
            end
            (x::Int, y::Vector) => begin
                result = mysort([x], y)
                result !== nothing && return result
            end
            
        end
    end
    return nothing
end

function main(filename)
    list = Vector{Any}()
    open(filename) do file
        for ln in eachline(file)
            if length(ln) > 0
                e = parseline(ln)
                # println(e, typeof(e))
                push!(list, e)
            end
        end
    end
    # list .|> el -> println(el, "\ttype = ", typeof(el))
    result = []
    pair = 1
    decoderkeys = [[2]] ,[[6]]
    sorted = copy(list)
    push!(sorted, decoderkeys[1], decoderkeys[2])
    sort!(sorted; lt=mysort)
    while !isempty(list)
        println("== Pair $pair ==")
        left = splice!(list, 1)
        right = splice!(list, 1)
        println("- Compare $left vs $right")
        if compare(left, right) === true
            push!(result, pair)
        end
        pair += 1
        println()
    end
    println("result = $result")
    println("sorted")
    sorted .|> println
    pos = findfirst(x -> x == decoderkeys[1], sorted), findfirst(x -> x === decoderkeys[2], sorted)
    return sum(result), pos[1] * pos[2]
end

for arg in ARGS
    res = main(arg)
    println(arg, " -> ", res)
end