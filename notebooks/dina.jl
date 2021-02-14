### A Pluto.jl notebook ###
# v0.12.20

using Markdown
using InteractiveUtils

# ╔═╡ 6b11d6da-6bab-11eb-1919-bddfe835570a
begin
	using Pkg
	Pkg.activate(temp = true)
	Pkg.add([
		Pkg.PackageSpec(name = "DINA", version = "0.1.1"),
		Pkg.PackageSpec(name = "DataAPI", version = "1.4"),
	])
	Pkg.add(["CairoMakie", "Revise", "CSV", "DataFrames", "PlutoUI"])
	
	#using UnPack: @unpack
	#using Chain: @chain
	import CSV
	using DINA
	using Dates: year
	using LinearAlgebra: dot
#	using Revise
	using PlutoUI: TableOfContents
	using DataFrames
	using CairoMakie

	
	#Base.show(io::IO, ::MIME"text/html", x::DINA.CategoricalArrays.CategoricalValue) = print(io, get(x))


end

# ╔═╡ c029567a-6bab-11eb-31d2-bd3b60724e99
md"""
# Distributional National Accounts
"""

# ╔═╡ dee716ce-6bab-11eb-1cdc-e18c5bf026a9
df80 = begin
	tbl = get_dina(1980)
	@assert tbl isa DINA.StatFiles.StatFile
	DataFrame(tbl)
end

# ╔═╡ 876ec3a8-6bb3-11eb-2d6c-39cfffb4d401
begin
	ids = [:id]
	grp = [:age]
	wgt = :dweght
	byvar = :peinc
	dbt_var = [:ownermort, :rentalmort, :nonmort, :hwdeb]
	var = [[:fiinc, :fninc, :ptinc, :peinc, :poinc, :ownerhome, :rentalhome]; dbt_var]
	cols = [ids; grp; wgt; var]
end

# ╔═╡ 31f69312-6bb1-11eb-220d-efd477af3e7a
df = dina_quantile_panel(var, byvar, 10; wgt)

# ╔═╡ aa5659fc-6be6-11eb-272c-09834723ab9b
size(df)

# ╔═╡ 11e25cc0-6e02-11eb-06ce-478cc66b8410
md"""
## Aggregate Debt

* `ownermort` mortgages for owner-occupied housing
* `rentalmort`: mortgages for tenant-occupied housing
* `nonmort`: non-mortgage debt
* `hwdebt`: total household debt (sum of the three above)
"""

# ╔═╡ f94d2ce4-6e01-11eb-3e0d-5f3a0d45f227
md"""
## Three Groups: Bottom 50, Middle 40, Top 10
"""

# ╔═╡ ad57105a-6bab-11eb-398b-3d52dcac3e84
md"""
# Appendix
"""

# ╔═╡ caeb9980-6ec4-11eb-3e36-932eb7e89720
md"""
## Download price data

[to be improved ...]
"""

# ╔═╡ d9212d4e-6ec4-11eb-2a24-5342bdf4fdff
begin
	gdpdef = CSV.File(IOBuffer(
"""
DATE	GDPDEF
1947-01-01	12.2662500000000000
1948-01-01	12.9542500000000000
1949-01-01	12.9345000000000000
1950-01-01	13.0880000000000000
1951-01-01	14.0227500000000000
1952-01-01	14.2650000000000000
1953-01-01	14.4392500000000000
1954-01-01	14.5722500000000000
1955-01-01	14.8172500000000000
1956-01-01	15.3225000000000000
1957-01-01	15.8322500000000000
1958-01-01	16.1905000000000000
1959-01-01	16.4132500000000000
1960-01-01	16.6380000000000000
1961-01-01	16.8140000000000000
1962-01-01	17.0190000000000000
1963-01-01	17.2137500000000000
1964-01-01	17.4767500000000000
1965-01-01	17.7955000000000000
1966-01-01	18.2945000000000000
1967-01-01	18.8252500000000000
1968-01-01	19.6257500000000000
1969-01-01	20.5900000000000000
1970-01-01	21.6772500000000000
1971-01-01	22.7747500000000000
1972-01-01	23.7565000000000000
1973-01-01	25.0605000000000000
1974-01-01	27.3225000000000000
1975-01-01	29.8405000000000000
1976-01-01	31.4877500000000000
1977-01-01	33.4400000000000000
1978-01-01	35.7845000000000000
1979-01-01	38.7665000000000000
1980-01-01	42.2740000000000000
1981-01-01	46.2737500000000000
1982-01-01	49.1317500000000000
1983-01-01	51.0447500000000000
1984-01-01	52.8917500000000000
1985-01-01	54.5665000000000000
1986-01-01	55.6680000000000000
1987-01-01	57.0402500000000000
1988-01-01	59.0510000000000000
1989-01-01	61.3700000000000000
1990-01-01	63.6722500000000000
1991-01-01	65.8217500000000000
1992-01-01	67.3197500000000000
1993-01-01	68.9162500000000000
1994-01-01	70.3870000000000000
1995-01-01	71.8645000000000000
1996-01-01	73.1792500000000000
1997-01-01	74.4417500000000000
1998-01-01	75.2792500000000000
1999-01-01	76.3655000000000000
2000-01-01	78.0732500000000000
2001-01-01	79.7897500000000000
2002-01-01	81.0505000000000000
2003-01-01	82.5510000000000000
2004-01-01	84.7730000000000000
2005-01-01	87.4147500000000000
2006-01-01	90.0637500000000000
2007-01-01	92.4825000000000000
2008-01-01	94.2887500000000000
2009-01-01	95.0027500000000000
2010-01-01	96.1067500000000000
2011-01-01	98.1152500000000000
2012-01-01	99.9987500000000000
2013-01-01	101.7512500000000000
2014-01-01	103.6322500000000000
2015-01-01	104.6225000000000000
2016-01-01	105.7190000000000000
2017-01-01	107.7050000000000000
2018-01-01	110.2917500000000000
2019-01-01	112.2615000000000000
2020-01-01	113.6112500000000000
"""
			)) |> DataFrame

	gdpdef.year = year.(gdpdef.DATE)
end

# ╔═╡ 302d69a4-6e02-11eb-2ee6-01bd650a5a63
agg_df = let
	df1 = select(df,
		:group_id,
		:age, :year, wgt, var...
	)
	
	filter!(:age => !in([65]), df1)
		
	df2 = combine(
		groupby(df1, :year),
		([v, wgt] => ((x,w) -> dot(x,w)/sum(w)) => v for v in var)...
	)
	
	df3 = leftjoin(df2, gdpdef, on = :year)
	rename!(df3, :GDPDEF => :prices)

	filter!(:prices => !ismissing, df3)
	
	disallowmissing!(df3)
	
	df3.prices = df3.prices ./ first(filter(:year => ==(1980), df3).prices)
	
	inc = :peinc
	
	transform!(df3, ([v, :prices] => ByRow(/) => "r_$(string(v))" for v in var)...)
	transform!(df2, ([d, inc] => ByRow(/) => string(d) * "2inc" for d in dbt_var)...)
end

# ╔═╡ 5ecf0b3c-6e02-11eb-280d-ef6617d94d3c
let d = agg_df
	fig = Figure()
	Label(fig[1,1], "Growth of Household-Debt-To-Income in the USA", tellwidth = false)
	ax1 = Axis(fig[2,1][1,1])
	ax2 = Axis(fig[2,1][1,2])
	
	box_attr = (color = :gray90, )
	label_attr = (padding = (3,3,3,3), )
	
	Box(fig[2,1][1,1, Top()]; box_attr...)
	Label(fig[2,1][1,1, Top()], "relative to 1980"; label_attr...)
	
	Box(fig[2,1][1,2, Top()]; box_attr...)
	Label(fig[2,1][1,2, Top()], "relative to total debt in 1980"; label_attr...)
	
	
	axs = [ax1, ax2]
	
	colors = [:blue, :red, :green, :orange]
	i80 = findfirst(d.year .== 1980)
	
	for (i,dbt) in enumerate(dbt_var)
		var = string(dbt) * "2inc"
		for (j, fractionof) in enumerate([var, :hwdeb2inc])
			lines!(axs[j], d.year, d[!,var]/d[i80,fractionof], label = string(dbt), color = colors[i])
		end
	end

	leg_attr = (orientation = :horizontal, tellheight = true, tellwidth = false)
	leg = Legend(fig[3,1], ax1; leg_attr...)
	
	fig
end

# ╔═╡ 339dee36-6d37-11eb-0b57-cf3dc61977a7
begin
	df1 = select(df,
		:group_id,
		:three_groups,
		:age, :year, wgt, var...
	)
	
	filter!(:age => !in([65]), df1)
	
	#transform!(df1, :grp_id => ByRow(x -> ifelse(x <= 5, "bottom 50", ifelse(x <= 9, "middle 40", "top 10"))) => :three_grps)
	
	df2 = combine(
		groupby(df1, [:three_groups, :year]),
		([v, wgt] => ((x,w) -> dot(x,w)/sum(w)) => v for v in var)...
	)
	
	df3 = leftjoin(df2, gdpdef, on = :year)
	rename!(df3, :GDPDEF => :prices)

	filter!(:prices => !ismissing, df3)
	
	disallowmissing!(df3)
	
	inc = :peinc
	
	df3.prices = df3.prices ./ first(filter(:year => ==(1980), df3).prices)
	
	transform!(df3, ([v, :prices] => ByRow(/) => "r_$(string(v))" for v in var)...)
	transform!(df3, [:ownermort, inc] => ByRow(/) => "mort2inc")
end



# ╔═╡ e8d56ff8-6d42-11eb-13c0-73e77a9df363
let
	fig = Figure()
	ax = Axis(fig[1,1], title="Growth of real pre-tax incomes across income groups")
	
	colors = [:blue, :red, :green]
	
	for (i,d) in enumerate(groupby(df3, :three_groups))
			i80 = findfirst(d.year .== 1980)
			lines!(ax, d.year, d.r_peinc ./ d.r_peinc[i80], label = only(unique(d.three_groups)), color = colors[i])
	end
	
	vlines!(ax, [1980, 2007])
	Legend(fig[1,2], ax)
	fig
end

# ╔═╡ 5406fb5e-6d3c-11eb-0723-4bc72209a494
let
	fig = Figure()
	ax = Axis(fig[1,1], title = "Mortgage-to-income by income group")
	
	colors = [:blue, :red, :green]
	
	for (i,d) in enumerate(groupby(df3, :three_groups))
			i80 = 17 #findfirst(d.year == 1980)
			lines!(ax, d.year, d.mort2inc ./ d.mort2inc[i80], label = only(unique(d.three_groups)), color = colors[i])
	end

	Legend(fig[1,2], ax)
	fig
end

# ╔═╡ bed05dd4-6ec4-11eb-239a-abfdf89aec2f
md"""
## Package environment
"""

# ╔═╡ bb5e7aa8-6bab-11eb-2d1e-6fa08cd912d0
TableOfContents()

# ╔═╡ Cell order:
# ╟─c029567a-6bab-11eb-31d2-bd3b60724e99
# ╠═dee716ce-6bab-11eb-1cdc-e18c5bf026a9
# ╠═876ec3a8-6bb3-11eb-2d6c-39cfffb4d401
# ╠═31f69312-6bb1-11eb-220d-efd477af3e7a
# ╠═aa5659fc-6be6-11eb-272c-09834723ab9b
# ╟─11e25cc0-6e02-11eb-06ce-478cc66b8410
# ╟─5ecf0b3c-6e02-11eb-280d-ef6617d94d3c
# ╠═302d69a4-6e02-11eb-2ee6-01bd650a5a63
# ╟─f94d2ce4-6e01-11eb-3e0d-5f3a0d45f227
# ╠═339dee36-6d37-11eb-0b57-cf3dc61977a7
# ╠═e8d56ff8-6d42-11eb-13c0-73e77a9df363
# ╠═5406fb5e-6d3c-11eb-0723-4bc72209a494
# ╟─ad57105a-6bab-11eb-398b-3d52dcac3e84
# ╟─caeb9980-6ec4-11eb-3e36-932eb7e89720
# ╟─d9212d4e-6ec4-11eb-2a24-5342bdf4fdff
# ╟─bed05dd4-6ec4-11eb-239a-abfdf89aec2f
# ╠═6b11d6da-6bab-11eb-1919-bddfe835570a
# ╠═bb5e7aa8-6bab-11eb-2d1e-6fa08cd912d0
