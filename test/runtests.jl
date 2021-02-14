using DINA
import CSV
using Test

@testset "DINA.jl" begin

    tbl = get_dina(1980)
    @test tbl isa DINA.StatFiles.StatFile

    @test sort(dina_years()) == [1962; 1964; 1966:2019]

    var = [:fiinc, :fninc, :ownermort, :ownerhome, :rentalmort, :rentalhome]
    df = dina_quantile_panel(var, :fiinc, 10)
    @test df isa DINA.DataFrames.DataFrame
    @test size(df) == (1530, 11)

    filename = joinpath(@__DIR__(), "dina-aggregated.csv")
    df |> CSV.write(filename)

    @show filename
end
