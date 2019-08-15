using StanModels, CSV

df = CSV.read(joinpath(@__DIR__, "..", "..", "data", "UCBadmit.csv"), delim=';');

# Preprocess data

df[!, :male] = [(df[!, :gender][i] == "male" ? 1 : 0) for i in 1:size(df, 1)];
df[!, :dept_id] = [Int(df[!, :dept][i][1])-64 for i in 1:size(df, 1)];

m13_2s = "
  data{
      int N;
      int N_depts;
      int applications[N];
      int admit[N];
      real male[N];
      int dept_id[N];
  }
  parameters{
      vector[N_depts] a_dept;
      real a;
      real bm;
      real<lower=0> sigma_dept;
  }
  model{
      vector[N] p;
      sigma_dept ~ cauchy( 0 , 2 );
      bm ~ normal( 0 , 1 );
      a ~ normal( 0 , 10 );
      a_dept ~ normal( a , sigma_dept );
      for ( i in 1:N ) {
          p[i] = a_dept[dept_id[i]] + bm * male[i];
          p[i] = inv_logit(p[i]);
      }
      admit ~ binomial( applications , p );
  }
";

# Define the Stanmodel and set the output format to :mcmcchains.

sm = SampleModel("m13_2s", m13_2s);

# Input data for cmdstan

m13_2_data = Dict(
  "N" => size(df, 1), 
  "N_depts" => maximum(df[!, :dept_id]), 
  "applications" => df[!, :applications],  
  "admit" => df[!, :admit], 
  "male" => df[!, :male],
  "dept_id"=> df[!, :dept_id]
);

# Sample using cmdstan

(sampleFile, log_file) = stan_sample(sm, data=m13_2_data);

# Describe the draws

if !(sample_file == nothing)
  chn = read_samples(sm)
  describe(chn)
end

