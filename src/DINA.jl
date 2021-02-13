module DINA

export get_dina, dina_years, aggregate_quantiles, dina_quantile_panel

using CategoricalArrays: cut
using Chain: @chain
using DataDeps: register, DataDep, @datadep_str, unpack
using DataFrames: DataFrames, DataFrame, disallowmissing!, groupby, combine, transform!
using LinearAlgebra: dot
using ReadableRegex: look_for, one_or_more, DIGIT
using StatFiles: StatFiles, load
using StatsBase: wquantile
using TableOperations
using Statistics: mean

function __init__()
    register(DataDep(
        "USDINA",
        """
        Dataset: Distributional National Accounts
        Authors: Piketty, Saez, Zucan
        Website: http://gabriel-zucman.eu/usdina/
        
        Use data under terms specified on the website. The details are described in Piketty, Saez & Zucman (2018).
        Please include this citation if you plan to use this database:
            Piketty, T., E. Saez & G. Zucman: 
            Distributional National Accounts: Methods and Estimates for the United States
            Quarterly Journal of Economics, 2018, 133 (2): 553-609.
        """,
        "https://eml.berkeley.edu/~saez/PSZ2020Dinafiles.zip",
        "1115e8bd58b5ed073670ee31a3fffd9f968e85b5bc365a81035a3fd679cdcc86",
        post_fetch_method=unpack
    ))
end

function dina_years()
	files_in_data_dir = readdir(@datadep_str("USDINA"))
	dta_files = filter(endswith(".dta"), files_in_data_dir)
	
	r = look_for(one_or_more(DIGIT))
	
	map(dta_files) do f
		year_string = match(r, f).match
		parse(Int, year_string)
	end
end

function get_dina(year)
    file = "USDINA/usdina$(year).dta"
    load(@datadep_str(file))
end

function dina_quantile_panel(var, byvar, ngroups, years = dina_years();
                             wgt = :dweght,
                             equalsplit_quantiles = true)
    mapreduce(vcat, years) do yr
        aggregate_quantiles(var, byvar, ngroups, yr; wgt, equalsplit_quantiles)
    end
end

function aggregate_quantiles(var, byvar, ngroups, year; wgt, equalsplit_quantiles)
	tbl0 = get_dina(year)
	
	ids = :id
	grp = [:age]
	
	cols = unique([ids; grp; wgt; var; byvar])
	
	tbl = TableOperations.select(tbl0, cols...)
	
	df = DataFrame(tbl) |> disallowmissing!
    
    filter!(ids => >(0), df)

    if equalsplit_quantiles
        byvar_equalsplit = string(byvar) * "_equalsplit"
        transform!(
            groupby(df, :id),
            byvar => mean => byvar_equalsplit
        )
        byvar = byvar_equalsplit
    end

    q = 0:1/ngroups:1
    
	df.group = cut(df[!,byvar], wquantile(df[!,byvar], df[!,wgt], q), extend=true, labels = format)
	
	agg_df = combine(
        groupby(df, [:group, :age]),
        ([v, wgt] => ((x,w) -> dot(x,w)./sum(w)) => v for v in var)..., wgt => sum => wgt
        )
    
    agg_df[!,:year] .= year
	
	agg_df
end

format(from, to, i; kwargs...) = "group $i"

end