struct Position
    x::Int
    y::Int
end

increment_x_position(p::Position, Δ:: Int) =  Position(p.x + Δ, p.y)
increment_y_position(p::Position, Δ:: Int) =  Position(p.x, p.y + Δ)
decrement_x_position(p::Position, Δ:: Int) =  increment_x_position(p, -Δ)
decrement_y_position(p::Position, Δ:: Int) =  increment_y_position(p, -Δ)

#=
move(direction, distance, head_position, tail_position)
    switch(direction):
        R -> head_position = increment_x_position(head_position, distance)
        L -> head_position = decrement_x_position(head_position, distance)
        U -> head_position = increment_y_position(head_position, distance)
        D -> head_position = decrement_y_position(head_position, distance)
    
=#

function move_according_direction(direction, position)
    if direction == "R"
        return increment_x_position(position, 1)
    end
    if direction == "L"
        return decrement_x_position(position, 1)
    end
    if direction == "U"
        return increment_y_position(position, 1)
    end
    if direction == "D"
       return decrement_y_position(position, 1)
    end
    throw("Invalid direction")
end

function main(filename, n = 1)
    open(filename) do file
        head, tails = Position(0,0), fill(Position(0,0), n)
        tail_history = Set([tails[end]])
        for line in eachline(file)
            direction, Δ = split(line, " ")
            steps = parse(Int, Δ)
            for _ in 1:steps
                head = move_according_direction(direction, head)
                prev = head
                for i in eachindex(tails)
                    tail = tails[i]
                    diff_x = prev.x - tail.x
                    diff_y = prev.y - tail.y
                    if abs(diff_x) > 1 || abs(diff_y) > 1 
                        tails[i] = Position(tail.x + sign(diff_x), tail.y + sign(diff_y))
                    end
                    prev = tails[i]
                end
                push!(tail_history, tails[end])
            end
        end
        println("tail_moves ", length(tail_history))
    end
end

for arg in ARGS
    main(arg, 9)
end