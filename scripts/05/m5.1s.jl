using StanModels

df = CSV.read(joinpath(@__DIR__, "..", "..", "data", "WaffleDivorce.csv"), delim=';')
mean_ma = mean(df[!, :MedianAgeMarriage])
df[!, :MedianAgeMarriage_s] = 
  convert(Vector{Float64},  (df[!, :MedianAgeMarriage]) .-
    mean_ma)/std(df[!, :MedianAgeMarriage]);

# Define the Stan language model

m5_1s = "
data {
 int < lower = 1 > N; // Sample size
 vector[N] divorce; // Predictor
 vector[N] median_age; // Outcome
}

parameters {
 real a; // Intercept
 real bA; // Slope (regression coefficients)
 real < lower = 0 > sigma; // Error SD
}

model {
  # priors
  a ~ normal(10, 10);
  bA ~ normal(0, 1);
  sigma ~ uniform(0, 10);
  
  # model
  divorce ~ normal(a + bA*median_age , sigma);
}
";

# Define the Stanmodel and set the output format to :mcmcchains.

sm = SampleModel("m5.1s", m5_1s);

# Input data for cmdstan

m5_1_data = Dict("N" => length(df[!, :Divorce]), "divorce" => df[!, :Divorce],
    "median_age" => df[!, :MedianAgeMarriage_s]);

# Sample using cmdstan

(sample_file, log_file) = stan_sample(sm, data=m5_1_data);

# Result rethinking

rethinking = "
       mean   sd  5.5% 94.5% n_eff Rhat
a      9.69 0.22  9.34 10.03  2023    1
bA    -1.04 0.21 -1.37 -0.71  1882    1
sigma  1.51 0.16  1.29  1.79  1695    1
"

# Describe the draws
if !(sample_file == nothing)
  chn = read_samples(sm)
  describe(chn)
end

