using StanModels

# Define the Stan language model

m8_3s = "
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

# Define the Stanmodel and set the output format to :mcmcchains.

sm = SampleModel("m8.3s", m8_3s);

# Input data for cmdstan

m8_3_data = Dict("N" => 2, "y" => [-1.0, 1.0]);
m8_3_init = Dict("alpha" => 0.0, "sigma" => 1.0);

# Sample using cmdstan

(sample_file, log_file) = stan_sample(sm, data=m8_3_data,  init=m8_3_init,
  summary=true);
  
rethinking = "
        mean   sd  5.5% 94.5% n_eff Rhat
alpha 0.06 1.90 -2.22  2.49  1321    1
sigma 2.15 2.32  0.70  5.21   461    1
";

# Describe the draws

if !(sample_file == nothing)
  chn = read_samples(sm)
  describe(chn)
end
