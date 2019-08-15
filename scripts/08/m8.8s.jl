using StanModels, Distributions

# ### snippet 8.25

N = 100                                          # individuals
height  = rand(Normal(10,2), N) ; # sim total height of each
leg_prop = rand(Uniform(0.4,0.5), N); # leg as proportion of height

# sim left leg as proportion + error
leg_left = leg_prop .* height .+  rand(Normal( 0 , 0.02 ), N);
# sim right leg as proportion + error
leg_right = leg_prop .* height .+  rand(Normal( 0 , 0.02 ), N);

# combine into data frame

df =  DataFrame(height=height, leg_left = leg_left, leg_right = leg_right);

# Show first 5 rows

first(df, 5)

# Define the Stan language model

m8_8s = "
data{
    int N;
    real height[N];
    real leg_right[N];
    real leg_left[N];
}
parameters{
    real a;
    real bl;
    real br;
    real sigma;
}
model{
    vector[N] mu;
    sigma ~ cauchy( 0 , 1 );
    br ~ normal( 2 , 10 );
    bl ~ normal( 2 , 10 );
    a ~ normal( 10 , 100 );
    for ( i in 1:100 ) {
        mu[i] = a + bl * leg_left[i] + br * leg_right[i];
    }
    height ~ normal( mu , sigma );
}
";

# Define the Stanmodel and set the output format to :mcmcchains.

sm = SampleModel("m8.8s", m8_8s);

# Input data for cmdstan

m8_8_data = Dict("N" => size(df, 1), "height" => df[!, :height],
    "leg_left" => df[!, :leg_left], "leg_right" => df[!, :leg_right]);

# Sample using cmdstan

(sample_file, log_file) = stan_sample(sm, data=m8_8_data);

# Describe the draws

if !(sample_file == nothing)
  chn = read_samples(sm)
  describe(chn)
end
