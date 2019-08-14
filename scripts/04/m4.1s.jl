using StanModels, CSV

howell = CSV.read(joinpath(@__DIR__, "..", "..", "data", "Howell1.csv"), delim=';')
df = filter(row -> row[:age] >= 18, howell)
first(df, 5)

heightsmodel = "
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

sm = SampleModel("m4.1s", heightsmodel);

heightsdata = Dict("N" => length(df[!, :height]), "h" => df[!, :height]);

(sample_file, log_file) = stan_sample(sm, data=heightsdata);

if !(sample_file == nothing)
  chn = read_samples(sm)
  describe(chn)
end
