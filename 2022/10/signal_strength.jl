using DataStructures

function enc_dec(q, el = 0)
    r = dequeue!(q)
    enqueue!(q, el)
    return r
end

function main(filename, rows, cols)
    open(filename) do file
        
        cycles = [1]
        n = 1
        queue = Queue{Int}(n)
        m = fill('.', rows * cols)

        for _ in 1:n 
            enqueue!(queue, 0)
        end

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