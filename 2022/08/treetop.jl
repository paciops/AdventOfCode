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

function main(filename)
    field = creatematrix(filename)
    # all numbers are in field
    #println(typeof(field))
    m, n = size(field)
    # trees on the border
    total = m * 2 + (n-2)*2
    # trees on the inside
    println("Field:")
    eachrow(field) .|> println
    for row in 2 : m-1
        for col in 2 : n-1
            total += visible((row, col), field, (m, n)) ? 1 : 0 
        end 
    end
    return total
end

for arg in ARGS
    println(arg, " -> ", main(arg))
end