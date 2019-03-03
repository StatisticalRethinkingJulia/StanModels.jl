using StanModels

ProjDir = rel_path_s("..", "scripts", "08")
cd(ProjDir)

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

stanmodel = Stanmodel(name="m_8_2", monitors = ["mu", "sigma"],
model=m_8_2, output_format=:mcmcchains);

m_8_2_data = Dict("N" => 2, "y" => [-1, 1]);
m_8_2_init = Dict("mu" => 0.0, "sigma" => 1.0);

rc, chn, cnames = stan(stanmodel, m_8_2_data, ProjDir,
init=m_8_2_init, diagnostics=false,
summary=true, CmdStanDir=CMDSTAN_HOME);

describe(chn)

# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl

