mutable struct Monkey_Data
    items:: Vector{Int}
    operation::Function
    test::Int
    if_true::Int
    if_false::Int
    inspected::Int
end

function fcnFromString(s)
    f = eval(Meta.parse("old -> " * s))
    return x -> Base.invokelatest(f, x)
end

function main(filename, rounds)
    monkeys = Vector{Monkey_Data}()
    open(filename) do file
        for line in eachline(file)
            line = strip(line)

            if startswith(line, "Monkey")
                eval(Meta.parse("operation(x) = x"))
                push!(monkeys, Monkey_Data([], fcnFromString("old"), 1, 0, 0, 0 ))
                continue
            end

            if startswith(line, "Starting items")
                items = split(split(line, ":")[2] |> strip, ",") .|> x -> parse(Int, x)
                monkey = monkeys[end]
                append!(monkey.items, items)
                continue
            end

            if startswith(line, "Operation")
                str = split(line, "new = ")[2]
                monkey = monkeys[end]
                monkey.operation = fcnFromString(str)

                continue
            end

            if startswith(line, "Test: divisible by")
                num = split(line, " by ")[2]
                monkey = monkeys[end]
                monkey.test = parse(Int, num)

                continue
            end

            if startswith(line, "If true:")
                num = split(line, "throw to monkey ")[2]
                monkey = monkeys[end]
                monkey.if_true = parse(Int, num)
                continue
            end

            if startswith(line, "If false:")
                num = split(line, "throw to monkey ")[2]
                monkey = monkeys[end]
                monkey.if_false = parse(Int, num)
                continue
            end

        end
    end

    #monkeys .|> x -> x.operation(1) .|> println

    for r in 1:rounds
        # println("Round $r")
        for monkey in monkeys
            while !isempty(monkey.items)
                item = popfirst!(monkey.items)
                monkey.inspected += 1
                calc = floor(Int, monkey.operation(item) / 3)
                # print("Worry level $calc ")
                # println("Could be divied by $(monkey.test)")
                if calc % monkey.test == 0
                    push!(monkeys[monkey.if_true + 1].items, calc)
                else
                    push!(monkeys[monkey.if_false + 1].items, calc)
                end
            end
        end
    end
    
    (monkeys .|> x -> x.inspected) |> sort |> x -> x[end] * x[end-1]
end

for arg in ARGS
    println(arg, " -> ", main(arg, 20))
end