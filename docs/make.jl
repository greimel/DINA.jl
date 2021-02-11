using DINA
using Documenter

makedocs(;
    modules=[DINA],
    authors="Fabian Greimel <fabgrei@gmail.com> and contributors",
    repo="https://github.com/greimel/DINA.jl/blob/{commit}{path}#L{line}",
    sitename="DINA.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://greimel.github.io/DINA.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/greimel/DINA.jl",
    devbranch = "main",
    push_preview = true,
)
