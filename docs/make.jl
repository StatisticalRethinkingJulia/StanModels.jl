using StanModels
using Literate
using Documenter

page_list = Array{Pair{String, Any}, 1}();
append!(page_list, [Pair("Home", "intro.md")]);
append!(page_list, [Pair("Functions", "index.md")])

makedocs(root = DOC_ROOT,
    modules = Module[],
    sitename = "StanModels.jl",
    authors = "Rob Goedman, Richard Torkar, and contributors.",
    pages = page_list
)

deploydocs(root = DOC_ROOT,
    repo = "github.com/StatisticalRethinkingJulia/StanModels.jl.git",
 )
