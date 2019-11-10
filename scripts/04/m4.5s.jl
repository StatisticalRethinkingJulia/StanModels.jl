using StanModels, CSV

df = filter(row -> row[:age] >= 18, 
  CSV.read(joinpath(@__DIR__, "..", "..", "data", "Howell1.csv"), delim=';'))
df[!, :weight_s] = (df[!, :weight] .- mean(df[!, :weight])) / std(df[!, :weight]);
df[!, :weight_s2] = df[!, :weight_s] .^ 2;

# Define the Stan language model

m4_5s = "
data{
    int N;
    real height[N];
    real weight_s2[N];
    real weight_s[N];
}
parameters{
    real a;
    real b1;
    real b2;
    real sigma;
}
model{
    vector[N] mu;
    sigma ~ uniform( 0 , 50 );
    b2 ~ normal( 0 , 10 );
    b1 ~ normal( 0 , 10 );
    a ~ normal( 178 , 100 );
    for ( i in 1:N ) {
        mu[i] = a + b1 * weight_s[i] + b2 * weight_s2[i];
    }
    height ~ normal( mu , sigma );
}
";

# Define the Stanmodel and set the output format to :mcmcchains.

sm = SampleModel("m4.5s", m4_5s);

# Input data for cmdstan

m4_5_data = Dict("N" => size(df, 1), "height" => df[!, :height],
"weight_s" => df[!, :weight_s], "weight_s2" => df[!, :weight_s2]);

# Sample using cmdstan

(sample_file, log_file)= stan_sample(sm, data=m4_5_data);

# Describe the draws
if !(sample_file == nothing)
  chn = read_samples(sm)
  #chn = set_names(chn, Dict("mu" => "μ", "sigma" => "σ"))
  describe(chn)
end