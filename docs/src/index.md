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

var = [:fiinc, :fninc, :ownermort, :ownerhome, :rentalmort, :rentalhome]
byvar = :fiinc # compute deciles of `:fiinc`

df = dina_quantile_panel(var, byvar, 10)

filename = joinpath(".", "dina-aggregated.csv") # hide
df |> CSV.write(filename) # hide

first(df, 5)
```

[download](./dina-aggregated.csv)


```@index
```

```@autodocs
Modules = [DINA]
```
