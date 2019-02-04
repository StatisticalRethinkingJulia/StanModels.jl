module StanModels

using Reexport 

@reexport using SR, CSV
@reexport using CmdStan, StanMCMCChain
@reexport using MCMCChain

using DataStructures
import SR: scriptentry

const src_path_s = @__DIR__

"""

# rel_path_s

Relative path using the StanModels src/ directory. 

### Example to get access to the chapters subdirectories
```julia
rel_path_s("..", "chapters")
```
"""
rel_path_s(parts...) = normpath(joinpath(src_path_s, parts...))

include("scriptentry_s.jl")
include("generate_s.jl")

export
  rel_path_s,
  script_dict_s,
  generate_s

end # module
