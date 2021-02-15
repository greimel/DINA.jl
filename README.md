# DINA

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://greimel.github.io/DINA.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://greimel.github.io/DINA.jl/dev/)
[![Build Status](https://github.com/greimel/DINA.jl/workflows/CI/badge.svg)](https://github.com/greimel/DINA.jl/actions)

This package uses DataDeps.jl to download the US distributional national accounts (DINA) dataset from [Gabriel Zucman's website](http://gabriel-zucman.eu/usdina/). The data are downloaded in bulk (>1GB) and stored in `.julia/datadeps/dina/`.

The dataset is described in Piketty, T, E. Saez and G. Zucman: **Distributional National Accounts: Methods and Estimates for the United States**, *Quarterly Journal of Economics, 2018, 133 (2): 553-609.*

The variables are described in [the codebook at Gabriel Zucman's website](http://gabriel-zucman.eu/files/PSZCodebook.pdf).

## Usage

Load the DINA micro-data by year

```julia
using DINA, DataFrames

tbl = get_dina(1980)
df80 = DataFrame(tbl)
```

or load a quantile-year panel (takes about 1-2 minutes for 1962--2019).

```julia
using DINA

inc = :peinc
wgt = :dweght

dbt_var = [:ownermort, :rentalmort, :nonmort, :hwdeb]
var = [[:fiinc, :fninc, :ptinc, inc, :poinc, :ownerhome, :rentalhome]; dbt_var]
byvar = inc # compute deciles of `:peinc`

df = dina_quantile_panel(var, byvar, 10)
```

This is a picture you can produce using `df`. Have a look at the documentation for the full code.

![](https://greimel.github.io/DINA.jl/stable/fig_dbt.svg)
