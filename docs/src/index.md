```@meta
CurrentModule = DINA
```

# DINA

```@eval

```
This package uses DataDeps.jl to download the distributional national accounts dataset from www.zucman.eu/usdina. The data are stored in `.julia/datadeps/dina/`. They can be accessed the following way.

## Getting the micro data for a year

```@example micro
using DINA, DataFrames

tbl = get_dina(1980)
df80 = DataFrame(tbl)
```

## Getting the decile-year panel for selected variables

```@example panel
using DINA
import CSV

var = [:fiinc, :fninc, :ownermort, :ownerhome, :rentalmort, :rentalhome]
byvar = :fiinc # compute deciles of `:fiinc`

df = dina_quantile_panel(var, byvar, 10)

filename = joinpath(".", "dina-aggregated.csv") #hide
df |> CSV.write(filename) #hide
nothing #hide
```

[download](./dina-aggregated.csv)


```@index
```

```@autodocs
Modules = [DINA]
```
