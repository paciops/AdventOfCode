struct Position
    x::Int
    y::Int
end

get_x(pos) = pos.x
get_y(pos) = pos.y

function isequal(a::Position, b::Position)
    return a.x == b.x && a.y == b.y
end

DEBUG = "DEBUG" in keys(ENV) && ENV["DEBUG"] == "true"

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

gen_row(i) = [i-1, i, i+1]

function into_square(origin, point)
    x_values = gen_row(origin.x)
    y_values = gen_row(origin.y)
    return point.x in x_values && point.y in y_values
end

function move_close_to(from_position, to_position)
    if into_square(to_position, from_position)
        DEBUG && println("point is into square")
        return from_position
    end
    
    DEBUG && println("point is not into square")

    x_dist = to_position.x - from_position.x
    y_dist = to_position.y - from_position.y

    DEBUG && println("distance on x = $x_dist")
    DEBUG && println("distance on y = $y_dist")

    delta_x = 0
    delta_y = 0

    if x_dist > 0
        delta_x = 1
    elseif x_dist < 0
        delta_x = -1
    end
    
    if y_dist > 0
        delta_y = 1
    elseif y_dist < 0
        delta_y = -1
    end
    
    return Position(from_position.x + delta_x, from_position.y + delta_y)
end

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

function move(direction, distance, head_position, tail_position, tail_moves, tail_history)
    if distance == 0
        return head_position, tail_position, tail_moves
    end
    head_position = move_according_direction(direction, head_position)
    new_tail_position = move_close_to(tail_position, head_position)
    if !isequal(new_tail_position, tail_position) #&& !(new_tail_position in tail_history)
        tail_moves = tail_moves + 1
        push!(tail_history, new_tail_position)
    end
    return move(direction, distance - 1, head_position, new_tail_position, tail_moves, tail_history)
end

function main(filename)
    open(filename) do file
        head, tail = Position(0,0), Position(0,0)
        tail_moves = 0
        tail_history = [tail]
        for line in eachline(file)
            direction, Δ = split(line, " ")
            Δ = parse(Int, Δ)
            head, tail, tail_moves = move(direction, Δ, head, tail, tail_moves, tail_history)
            DEBUG && println("Direction $direction, Delta $Δ")
            DEBUG && println("head $head")
            DEBUG && println("tail $tail")
            DEBUG && println("tail_moves $tail_moves")
            DEBUG && println()
        end
        println("tail_moves $tail_moves")
        #println("$tail_history")
        min_pos = Position(minimum(map(get_x, tail_history)), minimum(map(get_y, tail_history)))
        max_pos = Position(maximum(map(get_x, tail_history)), maximum(map(get_y, tail_history)))      
        println(min_pos)  
        println(max_pos)  
        println(zeros(max_pos.x - min_pos.x,max_pos.y - min_pos.y))
    end
end

for arg in ARGS
    main(arg)
end