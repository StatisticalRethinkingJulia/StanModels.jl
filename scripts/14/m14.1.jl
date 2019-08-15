using StanModels, CSV, Statistics

# Model written by Scott Spencer

df = CSV.read(joinpath(@__DIR__, "..", "..", "data", "WaffleDivorce.csv"), delim=';')
mean_ma = mean(df[!, :MedianAgeMarriage])
df[!, :MedianAgeMarriage_s] = 
  convert(Vector{Float64},  (df[!, :MedianAgeMarriage]) .-
    mean_ma)/std(df[!, :MedianAgeMarriage]);

m14_1s = "
  data {
    int N;
    vector[N] A;
    vector[N] R;
    vector[N] Dobs;
    vector[N] Dsd;
  }
  parameters {
    real a;
    real ba;
    real br;
    real<lower=0> sigma;
    vector[N] Dest;
  }
  model {
    vector[N] mu; 
    // priors
    target += normal_lpdf(a | 0, 10);
    target += normal_lpdf(ba | 0, 10);
    target += normal_lpdf(br | 0, 10);
    target += cauchy_lpdf(sigma | 0, 2.5);
  
    // linear model
    mu = a + ba * A + br * R;
  
    // likelihood
    target += normal_lpdf(Dest | mu, sigma);
  
    // prior for estimates
    target += normal_lpdf(Dobs | Dest, Dsd);
  }
  generated quantities {
    vector[N] log_lik;
    {
      vector[N] mu;
      mu = a + ba * A + br * R;
      for(i in 1:N) log_lik[i] = normal_lpdf(Dest[i] | mu[i], sigma);
    }
  }
";

sm = SampleModel("m14.1s", m14_1s)

m14_1_data = Dict(
  "N" => size(df, 1),
  "A" => df[!, :MedianAgeMarriage],
  "R" => df[!, :Marriage],
  "Dobs" => df[!, :Divorce],
  "Dsd" => df[!, :Divorce_SE]
)

(sample_file, log_file) = stan_sample(sm, data=m14_1_data)

if !(sample_file == nothing)
  chn = read_samples(sm)
  describe(chn)
end
