module DINA

export get_dina

using DataDeps
using StatFiles
using DataFrames: DataFrame

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
        #[checksum::Union{String,Vector{String}...},]; # Optional, if not provided will generate
        # keyword args (Optional):
        #fetch_method=fetch_default # (remote_filepath, local_directory_path)->local_filepath
        post_fetch_method=unpack
    ))
end

function get_dina(year) 
    file = "USDINA/usdina$(year).dta"
    load(@datadep_str(file)) |> DataFrame
end

end
