using StanSample, MCMCChains, Distributions

# Define the Stan language model

m2_1s = "
// Inferring a Rate
data {
  int N;
  int<lower=0> k[N];
  int<lower=1> n[N];
}
parameters {
  real<lower=0,upper=1> theta;
}
model {
  // Prior Distribution for Rate Theta
  theta ~ beta(1, 1);

  // Observed Counts
  k ~ binomial(n, theta);
}
";

# Define the Stanmodel.

m_2_1s = SampleModel("m2.1s", m2_1s);

# Use 16 observations

N = 15
d = Binomial(9, 0.66)
k = rand(d, N)
n = repeat([9], N)

# Input data for cmdstan

m2_1_data = Dict("N" => N, "n" => n, "k" => k);

# Sample using cmdstan
 
rc = stan_sample(m_2_1s, data=m2_1_data);

# Describe the draws

if success(rc)
  chn = read_samples(m_2_1s; output_format=:mcmcchains)
  describe(chn)
end
