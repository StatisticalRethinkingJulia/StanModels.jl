using StanModels

howell1 = CSV.read(joinpath(@__DIR__, "..", "..", "data", "Howell1.csv"), delim=';')
df = filter(row -> row[:age] >= 18, howell1)

max_height = maximum(df[!, :height])
min_height = minimum(df[!, :height])

heightsmodel = "
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

sm = SampleModel("m4.2s", heightsmodel);

heightsdata = Dict("N" => length(df[!, :height]), "h" => df[!, :height]);

(sample_file, log_file) = stan_sample(sm, data=heightsdata);

if !(sample_file == nothing)
  chn = read_samples(sm)
  describe(chn)
end
