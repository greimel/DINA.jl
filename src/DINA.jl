module DINA

export get_dina, dina_years, aggregate_quantiles, dina_quantile_panel

using CategoricalArrays: cut, recode, levels
using Chain: @chain
using DataDeps: register, DataDep, @datadep_str, unpack
using DataFrames: DataFrames, DataFrame, disallowmissing!,
    groupby, combine, transform!, select!, ByRow
using LinearAlgebra: dot
#using ProgressMeter: @showprogress
using ReadableRegex: look_for, one_or_more, DIGIT
using ReadStatTables: readstat
using StatsBase: quantile, weights
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
    DataFrame(readstat(@datadep_str(file)))
end

function dina_quantile_panel(var, byvar, ngroups, years = dina_years();
                             wgt = :dweght,
                             equalsplit = true)
    mapreduce(vcat, years) do yr
        aggregate_quantiles(var, byvar, ngroups, yr; wgt, by_taxunit = equalsplit)
    end
end

function aggregate_quantiles(var, byvar, ngroups, year; wgt, by_taxunit)
	df0 = get_dina(year)
	
	ids = :id
	grp = [:age]
    
    cols0 = unique([wgt; var; byvar])
	cols = unique([ids; grp; cols0])
    
    #@info df0
    df = @chain df0 begin
        select!(cols...)
        disallowmissing!
    end
    
    filter!(ids => >(0), df)

    if by_taxunit
        transform!(
            groupby(df, :id),
            cols0 .=> sum, 
            renamecols = false
        )
    end

    q = 0:1/ngroups:1
    
    # Cut byvar into groups (e.g. income into deciles)
    groups = cut(df[!,byvar], quantile(df[!,byvar], weights(df[!,wgt]), q), extend=true, labels = format)
    df.group_id = parse.(Int, string.(groups))

    # Aggregate by group
    agg_df = combine(
        groupby(df, [:group_id, :age]),
        ([v, wgt] => ((x,w) -> dot(x, w) / sum(w)) => v for v in var)..., wgt => sum => wgt
        )
    
    agg_df[!,:year] .= year

    # Other group indentiers
    df.group = recode(groups, (g_id => "group " * g_id for g_id in levels(groups))...)

    if ngroups == 10
        transform!(agg_df,
            :group_id => ByRow(x -> ifelse(x <= 5, "bottom 50", ifelse(x <= 9, "middle 40", "top 10"))) => :three_groups)
    end
    
    agg_df
end

format(from, to, i; kwargs...) = "$i"

end
