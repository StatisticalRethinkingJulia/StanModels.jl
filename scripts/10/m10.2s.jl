using StanModels, CSV

df = CSV.read(joinpath(@__DIR__, "..", "..", "data", "chimpanzees.csv"), delim=';');

# Define the Stan language model

m10_2s = "
data{
    int N;
    int pulled_left[N];
    int prosoc_left[N];
}
parameters{
    real a;
    real bp;
}
model{
    vector[N] p;
    bp ~ normal( 0 , 10 );
    a ~ normal( 0 , 10 );
    for ( i in 1:N ) {
        p[i] = a + bp * prosoc_left[i];
        p[i] = inv_logit(p[i]);
    }
    pulled_left ~ binomial( 1 , p );
}
";

# Define the Stanmodel and set the output format to :mcmcchains.

sm = SampleModel("m10.2s", m10_2s);

# Input data for cmdstan

m10_2_data = Dict("N" => size(df, 1), 
"pulled_left" => df[!, :pulled_left], "prosoc_left" => df[!, :prosoc_left]);

# Sample using cmdstan

(sample_file, log_file)= stan_sample(sm, data=m10_2_data);

# Result rethinking

rethinking = "
   mean   sd  5.5% 94.5% n_eff Rhat
a  0.04 0.12 -0.16  0.21   180 1.00
bp 0.57 0.19  0.30  0.87   183 1.01
";

# Describe the draws

if !(sample_file == nothing)
  chn = read_samples(sm)
  describe(chn)
end