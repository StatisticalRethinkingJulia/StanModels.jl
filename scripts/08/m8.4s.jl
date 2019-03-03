# Load Julia packages (libraries).

using StanModels

# CmdStan uses a tmp directory to store the output of cmdstan

ProjDir = rel_path_s("..", "scripts", "08")
cd(ProjDir)

# Define the Stan language model

m_8_4 = "
data{
  int N;
  vector[N] y;
}
parameters{
  real sigma;
  real alpha;
  real a1;
  real a2;
}
model{
  real mu;
  mu = a1 + a2;
  y ~ normal( mu , sigma );
}
";

# Define the Stanmodel and set the output format to :mcmcchains.

stanmodel = Stanmodel(name="m_8_4", monitors = ["alpha", "mu", "sigma"],
model=m_8_4, output_format=:mcmcchains);

# Input data for cmdstan

m_8_4_data = Dict("N" => 100, "y" => rand(Normal(0, 1), 100));

# Sample using cmdstan

rc, chn, cnames = stan(stanmodel, m_8_4_data, ProjDir, diagnostics=false,
  summary=true, CmdStanDir=CMDSTAN_HOME);
  
rethinking = "
        mean   sd  5.5% 94.5% n_eff Rhat
alpha 0.06 1.90 -2.22  2.49  1321    1
sigma 2.15 2.32  0.70  5.21   461    1
";

# Describe the draws

describe(chn)

# End of `m8.4s.jl`
