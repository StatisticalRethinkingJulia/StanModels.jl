function scale!(
  df::DataFrame, 
  vars::Vector{Symbol}, 
  ext="_s")

  for var in vars
    mean_var = mean(df[!, var])
    std_var = std(df[!, var])

    df[!, Symbol("$(String(var))$ext")] = 
      (df[:, var] .- mean_var)/std_var
  end
  df
end

function scale!(
  df::DataFrame, 
  var::Symbol, 
  ext="_s")

  mean_var = mean(df[!, var])
  std_var = std(df[!, var])

  df[!, Symbol("$(String(var))$ext")] = 
    (df[:, var] .- mean_var)/std_var

end
