using DINA
using Test

@testset "DINA.jl" begin

    tbl = get_dina(1980)
    @test tbl isa DINA.StatFiles.StatFile

    @test sort(dina_years()) == [1962; 1964; 1966:2019]

end
