using AdventOfCode2023
using Test

testfile = (i) -> AdventOfCode2023.readinput(abspath(joinpath(@__DIR__, "..", "data", "test$(i).txt")))

@testset "Day 1" begin
    inputtest = testfile(1)
    @test AdventOfCode2023.Day1.solve(inputtest) == 142
    println("Result day 1 part 1:\t", AdventOfCode2023.Day1.solve())
    @test AdventOfCode2023.Day1.solve(testfile("1.1"); partTwo=true) == 281
    println("Result day 1 part 2:\t", AdventOfCode2023.Day1.solve(;partTwo=true))
end