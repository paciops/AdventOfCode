struct Position
    x::Int
    y::Int
end

struct MatrixDimension
    topleft::Int
    toptright::Int
    bottomleft::Int
    bottomright::Int
end
function main(filename)
    open(filename) do file
        position = Position(0,0)
        dim = MatrixDimension(0,0,0,0)
        for line in eachline(file)
            direction, Δ = split(line, " ")
            Δ = parse(Int, Δ)
            if direction == "U"
                position = Position(position.x - Δ, position.y)
            elseif direction == "D"
                position = Position(position.x + Δ, position.y)
            elseif direction == "L"
                position = Position(position.x, position.y - Δ)
            elseif direction == "R"
                position = Position(position.x, position.y + Δ)
            end
        end
    end
end

for arg in ARGS
    main(arg)
end