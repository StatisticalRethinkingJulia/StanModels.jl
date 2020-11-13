using StanSample, MCMCChains

df = filter(row -> row[:age] >= 18, 
  CSV.read(joinpath(@__DIR__, "..", "..", "data", "Howell1.csv"), DataFrame))

max_height = maximum(df[!, :height])
min_height = minimum(df[!, :height])

m4_2s = "
data {
  int N;
  real h[N];
}
parameters {
  real<lower=0> sigma;
  real<lower=$(min_height),upper=$(max_height)> mu;
}
model {
  // Priors for mu and sigma
  mu ~ normal(178, 0.1);
  sigma ~ uniform( 0 , 50 );

  // Observed heights
  h ~ normal(mu, sigma);
}
";

m_4_2s = SampleModel("m4.2s", m4_2s);

m4_2_data = Dict("N" => size(df, 1), "h" => df[!, :height]);

rc = stan_sample(m_4_2s, data=m4_2_data);

if success(rc)
  chn = read_samples(m_4_2s; output_format=:mcmcchains)
  chn = replacenames(chn, Dict("mu" => "μ", "sigma" => "σ"))
  describe(chn)
end
