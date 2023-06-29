using TestItemRunner

@run_package_tests

@testitem "DINA.jl" begin   
    tbl = get_dina(1980)
    @test tbl isa DINA.DataFrames.DataFrame

    @test sort(dina_years()) == [1962; 1964; 1966:2019]

    var = [:fiinc, :fninc, :ownermort, :ownerhome, :rentalmort, :rentalhome]

    df_1980 = aggregate_quantiles(var, :fiinc, 10, 1980; wgt = :dweght, by_taxunit = true)

    df = dina_quantile_panel(var, :fiinc, 10, [1962; 1980;2007])
    sort!(df, [:year, :group_id, :age])
    @test abs(df.fiinc[1] - (-175.761)) < 0.01
    @test df isa DINA.DataFrames.DataFrame
    @test size(df) == (80, 11)
end

@testitem "Income group panel" begin
    using CSV: CSV

    var = [:fiinc, :peinc, :ptinc, :fninc, :ownermort, :ownerhome, :rentalmort, :rentalhome, :hwdeb, :nonmort]

    df = dina_quantile_panel(var, :fiinc, 10)
    @test df isa DINA.DataFrames.DataFrame
    @test size(df) == (1530, 15)

    filename = joinpath(@__DIR__(), "dina-aggregated.csv")
    sort!(df, [:year, :group_id, :age])
    df |> CSV.write(filename)
    
    @show filename  
end