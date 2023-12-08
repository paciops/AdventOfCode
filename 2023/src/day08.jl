module Day8

using AdventOfCode2023

extractnodes = (nodes::Array{String}) -> Dict(map(node -> node[1:3] => (node[8:10], node[13:15]), nodes))

function distancetonode(curr::String, cond:: Function, directions::BitVector, nodes::Dict)
    notfound = true
    count = 0
    while notfound
        for d in directions
            curr = d ? nodes[curr][1] : nodes[curr][2]
        end
        count += 1
        notfound = cond(curr)
    end
    return count * length(directions)
end

function lcmonnodes(directions::BitVector, nodes::Dict)
    # all starting nodes are the nodes that ends with `A`
    startingnodes = filter(k -> endswith(k, 'A') , keys(nodes)) |> collect
    endfunction = (node) -> !endswith(node, 'Z')
    return map(node -> distancetonode(node, endfunction, directions, nodes), startingnodes) |> lcm
end

function solve(input::String = AdventOfCode2023.readinput(8); parttwo = false)
    rawdirections, rawnodes... = string.(filter(!isempty, split(input, '\n')))
    nodes = extractnodes(rawnodes)
    directions = rawdirections |> collect .|> c -> c === 'L'
    return parttwo ? lcmonnodes(directions, nodes) : distancetonode("AAA", e -> e !== "ZZZ", directions, nodes)
end
    
end