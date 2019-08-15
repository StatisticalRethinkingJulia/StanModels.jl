using StanModels, CSV

df = CSV.read(joinpath(@__DIR__, "..", "..", "data", "chimpanzees.csv"), delim=';');

# Define the Stan language model

m10_1s = "
data{
    int N;
    int pulled_left[N];
}
parameters{
    real a;
}
model{
    real p;
    a ~ normal( 0 , 10 );
    pulled_left ~ binomial( 1 , inv_logit(a) );
}
";

# Define the Stanmodel and set the output format to :mcmcchains.

sm = SampleModel("m10.1s", m10_1s);

# Input data for cmdstan

m10_1_data = Dict("N" => size(df, 1), 
  "pulled_left" => df[!, :pulled_left]);

# Sample using cmdstan

(sample_file, log_file) = stan_sample(sm, data=m10_1_data);

# Result rethinking

rethinking = "
  mean   sd  5.5% 94.5% n_eff Rhat
a 0.32 0.09 0.18  0.46   166    1
";

# Describe the draws

if !(sample_file == nothing)
  chn = read_samples(sm)
  describe(chn)
end