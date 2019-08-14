using StanModels, CSV

howell1 = CSV.read(joinpath(@__DIR__, "..", "..", "data", "Howell1.csv"), delim=';')
df2 = filter(row -> row[:age] >= 18, howell1);

# Define the Stan language model

weightsmodel = "
data {
 int < lower = 1 > N; // Sample size
 vector[N] height; // Predictor
 vector[N] weight; // Outcome
}

parameters {
 real alpha; // Intercept
 real beta; // Slope (regression coefficients)
 real < lower = 0 > sigma; // Error SD
}

model {
 height ~ normal(alpha + weight * beta , sigma);
}

generated quantities {
} 
";

# Define the Stanmodel and set the output format to :mcmcchains.

sm = SampleModel("m4.3s", weightsmodel);

# Input data for cmdstan

heightsdata = Dict("N" => length(df2[!, :height]), "height" => df2[!, :height],
  "weight" => df2[!, :weight]);

# Sample using cmdstan

(sample_file, log_file) = stan_sample(sm, data=heightsdata)

# Describe the draws

if !(sample_file == nothing)
  chn = read_samples(sm)
  describe(chn)
end
