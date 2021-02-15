```@meta
CurrentModule = DINA
```

# DINA

```@eval

```

This package uses DataDeps.jl to download the US distributional national accounts (DINA) dataset from [Gabriel Zucman's website](http://gabriel-zucman.eu/usdina/). The data are downloaded in bulk (<1GB) and stored in `.julia/datadeps/dina/`.

The dataset is described in Piketty, T, E. Saez and G. Zucman: **Distributional National Accounts: Methods and Estimates for the United States**, *Quarterly Journal of Economics, 2018, 133 (2): 553-609.*

The variables are described in this document [the codebook at Gabriel Zucman's website](http://gabriel-zucman.eu/files/PSZCodebook.pdf).

## Getting the micro data for a year

```@example micro
using DINA, DataFrames

tbl = get_dina(1980)
df80 = DataFrame(tbl)

first(df80, 5)
```

## Getting the decile-year panel for selected variables

```@example panel
using DINA
import CSV

inc = :peinc
wgt = :dweght

dbt_var = [:ownermort, :rentalmort, :nonmort, :hwdeb]
var = [[:fiinc, :fninc, :ptinc, inc, :poinc, :ownerhome, :rentalhome]; dbt_var]
byvar = inc # compute deciles of `:peinc`

df = dina_quantile_panel(var, byvar, 10)

filename = joinpath(".", "dina-aggregated.csv") # hide
df |> CSV.write(filename) # hide

first(df, 5)
```

[download](./dina-aggregated.csv)

## Some plots

```@example panel
using DataFrames, CairoMakie
using CairoMakie: AbstractPlotting.wong_colors
using LinearAlgebra: dot

agg_df = let
    df1 = select(df,
	    :group_id,
	    :age, :year, wgt, var...
    )
			
    df2 = combine(
	    groupby(df1, :year),
	    ([v, wgt] => ((x,w) -> dot(x,w)/sum(w)) => v for v in var)...
    )
		
    transform!(df2, ([d, inc] => ByRow(/) => string(d) * "2inc" for d in dbt_var)...)
end

let d = agg_df
	fig = Figure()
	
	# Define Layout, Labels, Titles
	Label(fig[1,1], "Growth of Household-Debt-To-Income in the USA", tellwidth = false)
	axs = [Axis(fig[2,1][1,i]) for i in 1:2]
	
	box_attr = (color = :gray90, )
	label_attr = (padding = (3,3,3,3), )
	
	Box(fig[2,1][1,1, Top()]; box_attr...)
	Label(fig[2,1][1,1, Top()], "relative to 1980"; label_attr...)
	
	Box(fig[2,1][1,2, Top()]; box_attr...)
	Label(fig[2,1][1,2, Top()], "relative to total debt in 1980"; label_attr...)
	
	# Plot
	i80 = findfirst(d.year .== 1980)
	
	for (i,dbt) in enumerate(dbt_var)
		var = string(dbt) * "2inc"
		for (j, fractionof) in enumerate([var, :hwdeb2inc])
			lines!(axs[j], d.year, d[!,var]/d[i80,fractionof], label = string(dbt), color = wong_colors[i])
		end
	end

	# Legend
	leg_attr = (orientation = :horizontal, tellheight = true, tellwidth = false)
	leg = Legend(fig[3,1], axs[1]; leg_attr...)

    save("fig_dbt.svg", fig) # hide
	fig
    nothing # hide
end
```

![fig_dbt](fig_dbt.svg)


```@index
```

```@autodocs
Modules = [DINA]
```
