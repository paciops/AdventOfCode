using AdventOfCode2023
using Test

AdventOfCode2023.includedays()

testfile = (i) -> AdventOfCode2023.readinput(abspath(joinpath(@__DIR__, "..", "data", "test$(i).txt")))

@testset "Day 1" begin
    inputtest = testfile(1)
    @test AdventOfCode2023.Day1.solve(inputtest) == 142
    println("Result day 1 part 1:\t", AdventOfCode2023.Day1.solve())
    
    @test AdventOfCode2023.Day1.solve(testfile("1.1"); partTwo=true) == 281
    println("Result day 1 part 2:\t", AdventOfCode2023.Day1.solve(;partTwo=true))
end

@testset "Day 2" begin
    inputtest = testfile(2)
    @test AdventOfCode2023.Day2.solve(inputtest) == (8, 2286)
    println("Result day 2:\t", @time AdventOfCode2023.Day2.solve())
end

@testset "Day 3" begin
    inputtest = testfile(3)
    @test AdventOfCode2023.Day3.solve(inputtest) == (4361, 467835)
    println("Result day 3:\t", @time AdventOfCode2023.Day3.solve())
end

@testset "Day 4" begin
    inputtest = testfile(4)
    @test AdventOfCode2023.Day4.solve(inputtest) == (13, 30)
    println("Result day 4:\t", @time AdventOfCode2023.Day4.solve())
end

@testset "Day 5" begin
    inputtest = testfile(5)
    @test AdventOfCode2023.Day5.solve(inputtest) == (35, 46)
    # too slow to run every time
    # println("Result day 5:\t", @time AdventOfCode2023.Day5.solve())
end

@testset "Day 6" begin
    inputtest = testfile(6)
    @test AdventOfCode2023.Day6.solve(inputtest) == (288, 71503)
    println("Result day 6:\t", @time AdventOfCode2023.Day6.solve())
end

@testset "Day 7" begin
    inputtest = testfile(7)
    @test AdventOfCode2023.Day7.solve(inputtest) == (6440, 5905)
    println("Result day 7:\t", @time AdventOfCode2023.Day7.solve())
end

@testset "Day 8" begin
    inputtest = testfile(8)
    @test AdventOfCode2023.Day8.solve(inputtest) == (6)
    @test AdventOfCode2023.Day8.solve(testfile("8.1"); parttwo=true) == (6)
    println("Result day 8:\t", @time (AdventOfCode2023.Day8.solve(), AdventOfCode2023.Day8.solve(;parttwo=true)))
end