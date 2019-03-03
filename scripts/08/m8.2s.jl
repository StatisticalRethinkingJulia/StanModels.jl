# Load Julia packages (libraries) .

using StanModels

# CmdStan uses a tmp directory to store the output of cmdstan

ProjDir = rel_path_s("..", "scripts", "08")
cd(ProjDir)

# Define the Stan language model

m_8_2 = "
data{
    int N;
    vector[N] y;
}
parameters{
    real mu;
    real<lower=0> sigma;
}
model{
    y ~ normal( mu , sigma );
}
";

# Define the Stanmodel, set the output format to :mcmcchains.

stanmodel = Stanmodel(name="m_8_2", monitors = ["mu", "sigma"],
model=m_8_2, output_format=:mcmcchains);

# Input data for cmdstan

m_8_2_data = Dict("N" => 2, "y" => [-1, 1]);
m_8_2_init = Dict("mu" => 0.0, "sigma" => 1.0);

# Sample using cmdstan

rc, chn, cnames = stan(stanmodel, m_8_2_data, ProjDir, 
init=m_8_2_init, diagnostics=false,
summary=true, CmdStanDir=CMDSTAN_HOME);

# Describe the draws

describe(chn)

# End of `m8.2s.jl`
