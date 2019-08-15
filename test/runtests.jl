using StanModels
using Test

ProjDir = @__DIR__

include(joinpath(ProjDir, "..", "scripts", "02", "m2.1s.jl"))

include(joinpath(ProjDir, "..", "scripts", "04", "m4.1s.jl"))
include(joinpath(ProjDir, "..", "scripts", "04", "m4.2s.jl"))
include(joinpath(ProjDir, "..", "scripts", "04", "m4.3s.jl"))
include(joinpath(ProjDir, "..", "scripts", "04", "m4.4s.jl"))
include(joinpath(ProjDir, "..", "scripts", "04", "m4.5s.jl"))

include(joinpath(ProjDir, "..", "scripts", "05", "m5.1s.jl"))
include(joinpath(ProjDir, "..", "scripts", "05", "m5.3s.jl"))
include(joinpath(ProjDir, "..", "scripts", "05", "m5.5s.jl"))

include(joinpath(ProjDir, "..", "scripts", "08", "m8.1s.jl"))
include(joinpath(ProjDir, "..", "scripts", "08", "m8.2s.jl"))
include(joinpath(ProjDir, "..", "scripts", "08", "m8.3s.jl"))
include(joinpath(ProjDir, "..", "scripts", "08", "m8.4s.jl"))
include(joinpath(ProjDir, "..", "scripts", "08", "m8.5s.jl"))
include(joinpath(ProjDir, "..", "scripts", "08", "m8.8s.jl"))

include(joinpath(ProjDir, "..", "scripts", "10", "m10.1s.jl"))
include(joinpath(ProjDir, "..", "scripts", "10", "m10.2s.jl"))
include(joinpath(ProjDir, "..", "scripts", "10", "m10.4s.jl"))
include(joinpath(ProjDir, "..", "scripts", "10", "m10.4sl.jl"))

include(joinpath(ProjDir, "..", "scripts", "12", "m12.6s.jl"))
include(joinpath(ProjDir, "..", "scripts", "12", "m12.6sl.jl"))

include(joinpath(ProjDir, "..", "scripts", "13", "m13.2s.jl"))

include(joinpath(ProjDir, "..", "scripts", "14", "m14.1s.jl"))
