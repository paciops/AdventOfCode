using DelimitedFiles

function creatematrix(filename)
    matrix = Vector{Vector{Int}}()
    open(filename) do file
        for line in eachline(file)
            row = split(line, "") .|> x -> parse(Int, x)
            push!(matrix, row)
        end
    end
    return permutedims(hcat(matrix...))
end

function ismax(field, row, col, index, findfunction)
    # current value is in index
    # check if argmax is index
    list = field[row, col]
    listmax = maximum(list)
    result = findfunction(x -> x == listmax, list) == index
    #result && println("$list max is $listmax at index $index $((row, col))")
    return result
end

function visible((row, col), field, (m, n))
    return (ismax(field, 1:row, col, row, findfirst)) || (ismax(field, row:m, col, 1, findlast)) || (ismax(field, row, 1:col, col, findfirst)) || (ismax(field, row, col:n, 1, findlast))
end

function calcdist(field, (row, col), fun)
    list = field[row, col] |> fun
    l = length(list)
    el = list[1]
    dist = 0
    for i in 2:l
        dist += 1
        if list[i] >= el
            break
        end
    end
    return dist
end

function calcscenicscore(field, (row, col), (m, n))
    top = calcdist(field, (1:row, col), reverse)
    bottom = calcdist(field, (row:m, col), identity)
    left = calcdist(field, (row, 1:col), reverse)
    right = calcdist(field, (row, col:n), identity)
    return top * bottom * left * right
end

function main(filename, printfield = false)
    field = creatematrix(filename)
    # all numbers are in field
    #println(typeof(field))
    m, n = size(field)
    # trees on the border
    total = m * 2 + (n-2)*2
    # trees on the inside
    printfield && println("Field:")
    printfield && eachrow(field) .|> println
    bestscenicscore = 0
    for row in 2 : m-1
        for col in 2 : n-1
            v = visible((row, col), field, (m, n))
            total += v ? 1 : 0 
            if v
                scenicscore = calcscenicscore(field, (row, col), (m, n))
                if scenicscore > bestscenicscore
                    bestscenicscore = scenicscore
                end
            end
        end 
    end
    print(filename,  "\tvisible trees = ", total)
    print("\t scenic score = ", bestscenicscore)
    println("\t size = ", (m,n))
    return
end

for arg in ARGS
    main(arg)
end