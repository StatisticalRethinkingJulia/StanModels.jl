using StanModels

ProjDir = rel_path_s("..", "scripts", "08")
cd(ProjDir)

m_8_3 = "
data{
  int N;
  vector[N] y;
}
parameters{
  real<lower=0> sigma;
  real alpha;
}
model{
  real mu;
  alpha ~ normal( 1 , 10 );
  sigma ~ cauchy( 0 , 1 );
  mu = alpha;
  y ~ normal( mu , sigma );
}
";

stanmodel = Stanmodel(name="m_8_3", monitors = ["alpha", "mu", "sigma"],
model=m_8_3, output_format=:mcmcchains);

m_8_3_data = Dict("N" => 2, "y" => [-1.0, 1.0]);
m_8_3_init = Dict("alpha" => 0.0, "sigma" => 1.0);

rc, chn, cnames = stan(stanmodel, m_8_3_data, ProjDir, init=m_8_3_init,
 diagnostics=false, summary=true, CmdStanDir=CMDSTAN_HOME);

rethinking = "
        mean   sd  5.5% 94.5% n_eff Rhat
alpha 0.06 1.90 -2.22  2.49  1321    1
sigma 2.15 2.32  0.70  5.21   461    1
";

describe(chn)

# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl

