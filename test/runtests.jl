using DINA
using Test

@testset "DINA.jl" begin

    df = get_dina(1980)

    @show size(df)
    # Write your tests here.
end
