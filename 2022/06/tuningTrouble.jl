using DataStructures

function fromFile(file_name, n)
    open(file_name) do file
        for line in eachline(file)
            println(line, ": ", parse(line, n))
        end
    end
end

isValid(str, i, n) = counter(str[i:i+n])|> values |> list -> all(e -> e == 1, list)

function parse(string, n)
    l = length(string)
    for i in 1:l-n
        #println("$i) ", counter(string[i:i+n-1]))
        if isValid(string, i, n-1)
            return i + n - 1
        end
    end
    throw("Not found")
end

for arg in ARGS
    #println(arg, ": ", parse(arg, 14))
    fromFile(arg, 14)
end