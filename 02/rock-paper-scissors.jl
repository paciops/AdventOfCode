LOST = 0
DRAW = 3
WIN  = 6
X    = 1
Y    = 2
Z    = 3

function shapeToNumber(shape)
    if shape == 'A' || shape == 'X' 
        return 1
    end
    if shape == 'B' || shape == 'Y' 
        return 2
    end
    if shape == 'C' || shape == 'Z' 
        return 3
    end
    return error("shape = ",  shape, " type = ", typeof(shape))
end

function getResult(opponentShape, myShape)
    if  myShape - opponentShape  == 23
        return DRAW
    end
    if opponentShape == 'A'
        if myShape == 'Y'
            return WIN
        end
        return LOST
    end
    if opponentShape == 'B'
        if myShape == 'Z'
            return WIN
        end
        return LOST
    end
    if opponentShape == 'C'
        if myShape == 'X'
            return WIN
        end
        return LOST
    end
    return error("opponentShape = ", opponentShape)
end

shape2res =  Dict(
    'X' => LOST,
    'Y' => DRAW,
    'Z' => WIN,
)

res2shape = Dict(
    'A'=> Dict(
        LOST=> Z,
        DRAW=> X,
        WIN=>  Y,
    ),
    'B'=> Dict(
        LOST=> X,
        DRAW=> Y,
        WIN=>  Z,
    ),
    'C'=>  Dict(
        LOST=> Y,
        DRAW=> Z,
        WIN=>  X,
    )
)

function newResult(opp, me)
    res = shape2res[me]
    shape = res2shape[opp][res]
    return res + shape
end

function main(fileName)
    tot    = 0
    newTot = 0
    open(fileName) do file
        for ln in eachline(file)
            opponent = ln[1]
            me = ln[3]
            tot = tot + shapeToNumber(me) + getResult(opponent, me)
            newTot = newTot + newResult(opponent, me)
        end
    end
    return tot, newTot
end

println(main("input.txt"))