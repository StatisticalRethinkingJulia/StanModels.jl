using StanModels

ProjDir = @__DIR__
cd(ProjDir)

d = CSV.read(rel_path("..", "data", "chimpanzees.csv"), delim=';');
df = convert(DataFrame, d);

first(df, 5)

m_10_04 = "
data {
  int N;
  int<lower=0, upper=1> L[N];
  vector[N] P;
  vector[N] C;

  int<lower=1, upper=N> N_chimps;
  int<lower=1, upper=N_chimps> chimp[N];
}
parameters {
  real a_chimp[N_chimps];
  real bp;
  real bpc;
}
model {
  vector[N] p;
  target += normal_lpdf(a_chimp | 0, 10);
  target += normal_lpdf(bp | 0, 10);
  target += normal_lpdf(bpc | 0, 10);
  for (i in 1:N) p[i] = a_chimp[chimp[i]] + (bp + bpc * C[i]) * P[i];
  target += binomial_logit_lpmf(L | 1, p);
}
generated quantities {
  vector[N] log_lik;
  {
    vector[N] p;
    for(n in 1:N) {
      p[n] = a_chimp[chimp[n]] + (bp + bpc * C[n]) * P[n];
      log_lik[n] = binomial_logit_lpmf(L[n] | 1, p[n]);
    }
  }
}
";

stanmodel = Stanmodel(name="m_10_04",
model=m_10_04, output_format=:mcmcchains);

m_10_04_data = Dict("N" => size(df, 1), "N_chimps" => length(unique(df[:actor])),
"chimp" => df[:actor], "L" => df[:pulled_left],
"P" => df[:prosoc_left], "C" => df[:condition]);

rc, chn, cnames = stan(stanmodel, m_10_04_data, ProjDir, diagnostics=false,
  summary=false, CmdStanDir=CMDSTAN_HOME);

rethinking = "
      mean   sd  5.5% 94.5% n_eff Rhat
bp    0.84 0.26  0.43  1.26  2271    1
bpC  -0.13 0.29 -0.59  0.34  2949    1

a[1] -0.74 0.27 -1.16 -0.31  3310    1
a[2] 10.88 5.20  4.57 20.73  1634    1
a[3] -1.05 0.28 -1.52 -0.59  4206    1
a[4] -1.05 0.28 -1.50 -0.60  4133    1
a[5] -0.75 0.27 -1.18 -0.32  4049    1
a[6]  0.22 0.27 -0.22  0.65  3877    1
a[7]  1.81 0.39  1.22  2.48  3807    1
";

chn2 = set_section(chn, Dict(
  :parameters => ["bp", "bpc"],
  :pooled => ["a_chimp.$i" for i in 1:7],
  :generated => ["log_lik.$i" for i in 1:504],
  :internals => ["lp__", "accept_stat__", "stepsize__", "treedepth__", "n_leapfrog__",
    "divergent__", "energy__"]
  )
)

describe(chn2)

describe(chn2, section=:pooled)

# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl

