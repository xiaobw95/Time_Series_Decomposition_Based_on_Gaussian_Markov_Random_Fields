data {
  int<lower=0> N; // number of observations
	int<lower=0> J; // number of grid cells
	vector [N] xvar1;  //locations for observations
	vector [J-1] duxvar1;  //distances between unique locations
  int<lower=0> xrank1[N]; //rank order of location for each obs
	real y[N];  // response for obs j
}

transformed data {
  real muy;
	real sdy;
	muy = mean(y);
  sdy = sd(y);
}

parameters {
	real delta[J-1];
	real theta0;
	real<lower=0.0> sigma;
}
	  
transformed parameters{
	vector[J] theta;
	theta[1] = 5*sdy*theta0 + muy;
	for (j in 1:(J-1)){
	  theta[j+1] = delta[j]*sqrt(duxvar1[j]) + theta[j];
	  }
}

model {
  sigma ~ exponential(1);
	theta0 ~ normal(0, 1);
	delta ~ double_exponential(0, 1);
	for (i in 1:N){
	  y[i] ~ normal(theta[xrank1[i]], sigma); 
	  }
}

generated quantities {
  vector[N] log_lik;
  for (i in 1:N) {
    log_lik[i] = normal_lpdf(y[i] | theta[xrank1[i]], sigma);
  }
}
