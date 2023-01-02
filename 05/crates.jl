function parseCrates(string, n_stack)
    l = length(string)
    if l == 0
        return n_stack, true
    end
    n_stack = Int((l+1)/4)
    return n_stack, false
end

removeBrackets(line) = replace(line, "[" => "", "]" => "", " " => "") |> line -> split(line, "")
parseLine(line, skip) = replace(line, "    " => "[$skip] " , " " => "") |> String |> removeBrackets

function populateStacks(prev_lines, n_stack, skip = "#")
    # create <n_stack> arrays, each array is a stack
    stacks = Array{Array}(undef, n_stack)
    for i in 1:n_stack
        stacks[i] = Vector{String}()
    end
    # reverse <prevLines> and skip empy line and number line
    for line in prev_lines |> reverse |> x -> x[3:end]
        #println("line pre parse = ", line)
        line = parseLine(line, skip)
        #println("line = ", line)
        for (i, v) in enumerate(line)
            v != skip && push!(stacks[i], v)
        end
    end

    return stacks
end

function parseMoves!(line, stacks)
    #println("Parsing line = $line")
    line = replace(line, "move" => "", "from" => "", "to" => "")
    qnt, from, to = split(line) .|> e -> parse(Int, e)
    # for (i, s) in enumerate(stacks)
    #     println("$i) $s")
    # end
    # println("line = $line")
    e = length(stacks[from])
    s = e - qnt + 1
    el = splice!(stacks[from], s:e)
    stacks[to] = append!(stacks[to], el)
    return
end

function main(fileName)
    n_stack = 0
    prev_lines = []
    stacks = Array{Array{String}}(undef, 0)
    open(fileName) do file
        for line in eachline(file)
            push!(prev_lines, line)
            n_stack, stop = parseCrates(line, n_stack)
            if stop
                break
            end
        end
        println("So there are ", n_stack, " stacks, let's populate them")
        
        stacks = populateStacks(prev_lines, n_stack)
        for line in eachline(file)
            parseMoves!(line, stacks)
        end
    end
    return stacks .|> last |> join
end

println(main("input.txt"))