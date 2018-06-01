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
	real delta1[J+10];
	real theta0;
	real delta0;
	real<lower=0.0> sigma;
	real<lower=0.0, upper=1.0> rho;
}

transformed parameters{
	vector[J+12] theta;
	real delta[J+11];
	delta[1] = delta0;
	for (j in 1:(J+10)){
	  delta[j+1] = delta1[j] + delta[j];
	  }
	theta[1] = 5*sdy*theta0 + muy;
	for (j in 1:(J+11)){
	  theta[j+1] = delta[j] + rho * theta[j];
	  }
}

model {
  sigma ~ exponential(1);
	theta0 ~ normal(0, 1);
	delta0 ~ normal(0, 10);
	delta1 ~ normal(0, 1);
	rho ~ normal(0, 1);
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
