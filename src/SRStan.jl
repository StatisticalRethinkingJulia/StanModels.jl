module StatisticalRethinking

using Reexport 

@reexport using Distributions, RDatasets, DataFrames
@reexport using StatsBase, StatsPlots, StatsFuns 
@reexport using CSV, DelimitedFiles, Serialization
@reexport using MCMCChain

using DataStructures

const src_path = @__DIR__

"""

# rel_path_s

Relative path using the StatisticalRethinking src/ directory. Copied from
[DynamicHMCExamples.jl](https://github.com/tpapp/DynamicHMCExamples.jl)

### Example to get access to the data subdirectory
```julia
rel_path_s("..", "data")
```
"""
rel_path_s(parts...) = normpath(joinpath(src_path, parts...))

include("maximum_a_posteriori.jl")
include("link.jl")
include("scriptentry.jl")
include("generate.jl")

export
  maximum_a_posteriori,
  link,
  rel_path_s,
  ScriptEntry,
  script_dict,
  generate

end # module
