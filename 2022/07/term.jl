struct File
    name::String
    dimension::Int
end

mutable struct FolderNode
    name::String
    dimension::Int
    folders::Vector{FolderNode}
    files::Vector{File}
    parent::Union{FolderNode, Nothing}
end

function print_node(current::FolderNode, padding = "", inc = " ")
    println("|$padding$(current.name)\t$(current.dimension)")
    padding *= inc
    for file in current.files
        println("$padding$(file.name)\t$(file.dimension)")
    end
    for dir in current.folders
        print_node(dir, padding, inc)
    end
end

function parseLine!(line::String, current::FolderNode, root::FolderNode)
    res = split(line, " ") .|> String 
    l = length(res)
    if l == 2
        ## ls and dim, file line
        one, two = res
        if one == "\$"
        elseif one == "dir"
            push!(current.folders, FolderNode(two, 0, [], [], current))
        else
            # <one> is a number containing file <two> dimension
            file = File(two, parse(Int, one))
            push!(current.files, file)
            current.dimension += file.dimension
            # adding dimension also to parent folder recursively
            tmp = current.parent
            while tmp !== nothing
                tmp.dimension += file.dimension
                tmp = tmp.parent
            end
        end
    elseif l == 3
        _, cmd, dir = res
        if cmd == "cd"
            if dir == "/"
                current = root
            elseif dir == ".."
                if current.parent === nothing
                    throw("Cannot change from $(current.name) to parent")
                end
                current = current.parent
            else
                index = findfirst(folder -> folder.name == dir, current.folders)
                if index === nothing
                    println(current)
                    throw("Folder $dir not found in $(current.name)")
                else
                    #println("Changing from $(current.name) to $(current.folders[index].name)")
                    current = current.folders[index]
                end
            end
        else
            throw("Command not found $line")
        end
    else
        throw("Something went wrong parsing $line")
    end
    return current
end

function find_folders(node::FolderNode, limit::Int)
    #println("Searching into $(node.name)")
    s = 0
    for dir in node.folders
        #println(dir.name, " --> ", dir.dimension)
        if dir.dimension <= limit
            s += dir.dimension
        end
        s += find_folders(dir, limit)
    end
    return s
end

function find_smaller_rec(folders::Vector{FolderNode}, need_space::Int)
    smaller = nothing
    for dir in sort(folders, by = x -> x.dimension)
        if dir.dimension >= need_space
            # let's check in subfolder
            #println(dir.name, " -> ", dir.dimension)
            smaller = (dir.name, dir.dimension)
            sub_smaller = find_smaller_rec(dir.folders, need_space)
            if sub_smaller !== nothing
                smaller = sub_smaller
            end
        end
    end
    return smaller
end

function main(file_name)
    root = FolderNode("/", 0, [], [], nothing)
    current = root
    open(file_name) do file
        for line in eachline(file)
            current = parseLine!(line, current, root)
        end
    end
    #print_node(root, "", "-")
    limit = 100000
    total_space = 70000000
    free_space = total_space - root.dimension
    println("Sum of dir dimension under $limit = ", find_folders(root, limit))

    result = find_smaller_rec(root.folders, 30000000 - free_space)
    println("smaller = ", result)
end

for arg in ARGS
    main(arg)
end