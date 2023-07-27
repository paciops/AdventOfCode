openbracket = c -> c == '['
closebracket = c -> c == ']'

function findbracket(str)
    start = nothing
    count = 0
    positions = []
    for i in eachindex(str)
        c = str[i]
        if openbracket(c)
            if count == 0
                start = i
            end
            count += 1
        elseif closebracket(c)
            if count == 1
                push!(positions, (start, i))
            end
            count -=1
        end
    end
    return positions
end

function parseline(original::String)
    return eval(Meta.parse(original))
end

function compare(left, right)
    println("- Compare $left vs $right")
    leftlen = length(left)
    rightlen = length(right)
    for i in 1:max(leftlen, rightlen)
        if i > leftlen
            println("  - Left side ran out of items, so inputs are in the right order")
            return true
        elseif i > rightlen
            println("  - Right side ran out of items, so inputs are not in the right order")
            return false
        end
        currleft = left[i]
        currright = right[i]
        println("  - Compare $currleft vs $currright")
        if left[i] isa Vector && right[i] isa Vector
            return compare(currleft, currright)
        end
        if typeof(currleft) != typeof(currright)
            if left[i] isa Vector
                currright = [currright]
                println("    - Mixed types; convert right to $currright and retry comparison")
            else
                currleft = [currleft]
                println("    - Mixed types; convert left to $currleft and retry comparison")
            end
            return compare(currleft, currright)
        elseif currleft < currright
            println("    - Left side is smaller, so inputs are in the right order")
            return true
        elseif currleft > currright
            println("    - Right side is smaller, so inputs are not in the right order")
            return false
        end
    end
    throw("should not be here")
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
    while !isempty(list)
        println("== Pair $pair ==")
        left = splice!(list, 1)
        right = splice!(list, 1)
        if compare(left, right)
            push!(result, pair)
        end
        pair += 1
        println()
    end
    println("result = ", result)
    return sum(result)
end

for arg in ARGS
    res = main(arg) 
    println(arg, " -> ", res)
end