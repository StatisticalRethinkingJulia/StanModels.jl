# Load Julia packages (libraries) needed

using StanModels

# CmdStan uses a tmp directory to store the output of cmdstan

ProjDir = @__DIR__
cd(ProjDir)

# Define the Stan language model

binomial = "
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

stanmodel = SampleModel("binomial", binomial);

# Use 16 observations

N = 15
d = Binomial(9, 0.66)
k = rand(d, N)
n = repeat([9], N)

# Input data for cmdstan

binomialdata = Dict("N" => N, "n" => n, "k" => k);

# Sample using cmdstan
 
(sample_file, log_file) = stan_sample(stanmodel, data=binomialdata);

# Describe the draws

if !(sample_file == nothing)
  chn = read_samples(stanmodel)
  describe(chn)
end

# End of `clip_08s.jl`
