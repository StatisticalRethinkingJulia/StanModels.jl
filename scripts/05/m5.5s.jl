using StanModels, CSV

df = CSV.read(joinpath(@__DIR__, "..", "..", "data", "milk.csv"), delim=';')
dcc = filter(row -> !(row[:neocortex_perc] == "NA"), df)
dcc[!, :kcal_per_g] = convert(Vector{Float64}, dcc[!, :kcal_per_g])
dcc[!, :neocortex_perc] = parse.(Float64, dcc[!, :neocortex_perc])

# Show first 5 rows

first(dcc, 5)

# Define the Stan language model

m5_5s = "
data{
    int N;
    vector[N] kcal_per_g;
    vector[N] neocortex_perc;
}
parameters{
    real a;
    real bn;
    real sigma;
}
model{
    vector[N] mu = a + bn * neocortex_perc;
    sigma ~ uniform( 0 , 1 );
    bn ~ normal( 0 , 1 );
    a ~ normal( 0 , 100 );
    kcal_per_g ~ normal( mu , sigma );
}
";

# Define the Stanmodel and set the output format to :mcmcchains.

sm = SampleModel("m5.5s", m5_5s);

# Input data for cmdstan

m5_5_data = Dict("N" => size(dcc, 1), 
  "kcal_per_g" => dcc[!, :kcal_per_g],
  "neocortex_perc" => dcc[!, :neocortex_perc]);

# Sample using cmdstan

(sample_file, log_file) = stan_sample(sm, data=m5_5_data);

# Rethinking results

rethinking_results = "
       mean   sd  5.5% 94.5%
 a     0.04 0.15 -0.21  0.29
 bN    0.13 0.22 -0.22  0.49
 sigma 1.00 0.16  0.74  1.26
"

# Describe the draws
if !(sample_file == nothing)
  chn = read_samples(sm)
  describe(chn)
end

