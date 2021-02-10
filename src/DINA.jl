module DINA

export get_dina, dina_years

using DataDeps
using StatFiles
using DataFrames: DataFrame
using ReadableRegex: look_for, one_or_more, DIGIT

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

end
