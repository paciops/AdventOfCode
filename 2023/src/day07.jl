module Day7

using DataStructures

using AdventOfCode2023

function parseinput(input::String)
    return split(input, '\n') .|> (line -> split(line, ' ') |> values -> (string(values[1]), AdventOfCode2023.parseint(values[2])))
end

CardsCounterBid = Tuple{String, Accumulator, Int}

cardsorderOne =  ['A', 'K', 'Q', 'J', 'T', '9', '8', '7', '6', '5', '4', '3', '2']
cardsorderTwo =  ['A', 'K', 'Q', 'T', '9', '8', '7', '6', '5', '4', '3', '2', 'J']

JOLLY = 'J'

function best(cardcounterbid::CardsCounterBid)
    # change accumulator to the best version
    acc = cardcounterbid[2]
    if acc[JOLLY] === 0 || acc[JOLLY] === 5
        return cardcounterbid
    end
    hand = cardcounterbid[1]
    bestcard = findmax(delete!(Dict(acc), JOLLY))[2]
    acc = counter(replace(hand, JOLLY=> bestcard))
    return (hand, acc, cardcounterbid[3])
end

function sortcards(cardscounterbid; partTwo = false)
    cardsorder = partTwo ? cardsorderTwo : cardsorderOne
    cardscounterbid = partTwo ? map(best, cardscounterbid) : cardscounterbid
    carddif = (acard, bcard) -> begin
        aindex = findfirst(el -> el == acard, cardsorder)
        bindex = findfirst(el -> el == bcard, cardsorder)
        return aindex - bindex
    end
    lessthancards = (a::CardsCounterBid, b::CardsCounterBid) -> begin
        akind = sort(values(a[2])|> collect; lt=!isless)
        bkind = sort(values(b[2])|> collect; lt=!isless)
        if akind == bkind
            # ordering rule takes effect
            ahand = a[1]
            bhand = b[1]
            n = min(length(ahand), length(bhand))
            for i = 1:n
                delta = carddif(ahand[i], bhand[i])
                delta > 0 && return true
                delta < 0 && return false
            end
            return true
        else
            n = min(length(akind), length(bkind))
            for i = 1:n
                akind[i] > bkind[i] && return false
                akind[i] < bkind[i] && return true
            end
            return false
        end 
    end
    return sort(cardscounterbid; lt=lessthancards)
end

function solve(input::String = AdventOfCode2023.readinput(7))
    cardscounterbid = map(((hand, bid),)-> (hand, counter(hand), bid), parseinput(input))
    bidprod = ((i, el),) -> i * el[3]
    partone = enumerate(sortcards(cardscounterbid))
    parttwo = enumerate(sortcards(cardscounterbid; partTwo = true))
    return sum(bidprod, partone), sum(bidprod, parttwo)
end

end