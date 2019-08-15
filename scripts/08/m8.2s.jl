using StanModels

# Define the Stan language model

m_8_2 = "
data{
    int N;
    vector[N] y;
}
parameters{
    real mu;
    real<lower=0> sigma;
}
model{
    y ~ normal( mu , sigma );
}
";

# Define the Stanmodel.

sm = SampleModel("m_8_2", m_8_2);

# Input data for cmdstan

m_8_2_data = Dict("N" => 2, "y" => [-1, 1]);
m_8_2_init = Dict("mu" => 0.0, "sigma" => 1.0);

# Sample using cmdstan

(sample_file, log_file) = stan_sample(sm; data=m_8_2_data, init=m_8_2_init);

# Describe the draws
if !(sample_file == nothing)
  chn = read_samples(sm)
  describe(chn)
end