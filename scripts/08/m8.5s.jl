using StanModels, Distributions

# Define the Stan language model

m8_5s = "
data{
  int N;
  vector[N] y;
}
parameters{
  real sigma;
  real a1;
  real a2;
}
model{
  real mu;
  a1 ~ normal(0, 10);
  a2 ~ normal(0, 10);
  mu = a1 + a2;
  y ~ normal( mu , sigma );
}
";

# Define the Stanmodel and set the output format to :mcmcchains.

sm = SampleModel("m8.5s", m8_5s);

# Input data for cmdstan

m8_5_data = Dict("N" => 100, "y" => rand(Normal(0, 1), 100));

# Sample using cmdstan

(sample_file, log_file) = stan_sample(sm, data=m8_5_data);
  
rethinking = "
       mean   sd   5.5% 94.5% n_eff Rhat
a1    -0.08 7.15 -11.34 11.25  1680    1
a2    -0.05 7.15 -11.37 11.19  1682    1
sigma  0.90 0.07   0.81  1.02  2186    1
";

# Describe the draws
if !(sample_file == nothing)
  chn = read_samples(sm)
  describe(chn)
end
