using StanModels, StanSample, MCMCChains, CSV

DataDir = stanmodels_path("..", "data", "exp_pro")
df = DataFrame!(CSV.File(joinpath(DataDir, "Howell1.csv"), delim=';'))
df = filter(row -> row[:age] >= 18, df)

m4_1s = "
// Inferring a Rate
data {
  int N;
  real<lower=0> h[N];
}
parameters {
  real<lower=0> sigma;
  real<lower=0,upper=250> mu;
}
model {
  // Priors for mu and sigma
  mu ~ normal(178, 20);
  sigma ~ uniform( 0 , 50 );

  // Observed heights
  h ~ normal(mu, sigma);
}
";

m_4_1s = SampleModel("m4.1s", m4_1s);

m4_1_data = Dict("N" => length(df[!, :height]), "h" => df[!, :height]);

rc = stan_sample(m_4_1s, data=m4_1_data);

if success(rc)
  stan_summary(m_4_1s, true)
  chn = read_samples(m_4_1s; output_format=:mcmcchains)
  # Update parameter names
  chn = replacenames(chn, Dict("mu" => "μ", "sigma" => "σ"))
  chn |> display
end
]