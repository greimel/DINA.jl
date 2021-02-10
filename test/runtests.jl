using DINA
using Test

@testset "DINA.jl" begin

    df = get_dina(1980)

    @show size(df)

    @test sort(dina_years) == [1962; 1964; 1966:2019]

    # Write your tests here.
end
