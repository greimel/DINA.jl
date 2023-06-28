using TestItemRunner

@run_package_tests

@testitem "DINA.jl" begin
    import CSV
   
    tbl = get_dina(1980)
    @test tbl isa DINA.DataFrames.DataFrame

    @test sort(dina_years()) == [1962; 1964; 1966:2019]

    var = [:fiinc, :fninc, :ownermort, :ownerhome, :rentalmort, :rentalhome]

    df_1980 = aggregate_quantiles(var, :fiinc, 10, 1980; wgt = :dweght, by_taxunit = true)

    df = dina_quantile_panel(var, :fiinc, 10, [1980;2007])
    @test df isa DINA.DataFrames.DataFrame
    @test size(df) == (60, 11)

end

@testitem "Income group panel" begin
    var = [:fiinc, :fninc, :ownermort, :ownerhome, :rentalmort, :rentalhome]

    df = dina_quantile_panel(var, :fiinc, 10)
    @test df isa DINA.DataFrames.DataFrame
    @test size(df) == (1530, 11)

    filename = joinpath(@__DIR__(), "dina-aggregated.csv")
    df |> CSV.write(filename)
    
    @show filename
    
end