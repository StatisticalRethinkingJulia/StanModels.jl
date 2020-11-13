using StanSample, MCMCChains, CSV

df = filter(row -> row[:age] >= 18, 
  CSV.read(joinpath(@__DIR__, "..", "..", "data", "Howell1.csv"), DataFrame))

stan4_1 = "
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

m4_1s = SampleModel("m4.1s", stan4_1);

m4_1_data = Dict("N" => length(df[!, :height]), "h" => df[!, :height]);

rc4_1s = stan_sample(m4_1s, data=m4_1_data);

if success(rc4_1s)
  #chn4_1s = read_samples(m4_1s; output_format=:mcmcchains)
  # Update parameter names
  #chn4_1s = replacenames(chn4_1s, Dict("mu" => "μ", "sigma" => "σ"))
  #chn4_1s

  part4_1s = read_samples(m4_1s; output_format=:particles)
  part4_1s |> display
end
