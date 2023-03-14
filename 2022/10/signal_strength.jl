using DataStructures

function main(filename, rows, cols)
    open(filename) do file
        
        cycles = [1]
        m = fill('.', rows * cols)

        for line in eachline(file)
            command = first(split(line, " "))
            if command == "noop"
                push!(cycles, cycles[end])
            elseif command == "addx"
                push!(cycles, cycles[end])
                value = parse(Int, last(split(line, " ")))
                push!(cycles, cycles[end] + value)
            end
        end

        s = 0
        offset = 0
        enumerate(cycles) .|> println
        for (i, value) in enumerate(cycles)
            if (i - 20) % 40 == 0
                #println(i, ") ", value)
                s  += value * i
            end
            if (i-offset-1) in [value - 1, value, value + 1]
                m[i] = '#'
            end
            i > rows * cols && break
            print(m[i])
            if (i) % 40 == 0 
                println()
                offset += cols
            end

        end 
        println(s)
        println()
    end
end

for arg in ARGS
    main(arg, 6, 40)
end