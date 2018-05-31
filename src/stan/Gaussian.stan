data {
  int<lower=0> N; // number of observations
	int<lower=0> J; // number of grid cells
	vector [N] xvar1;  //locations for observations
	vector [J+11] duxvar1;  //distances between unique locations
  int<lower=0> xrank1[N]; //rank order of location for each obs
	int <lower=0> y[N];  // response for obs j
}

transformed data {
	real muy;
	real sdy;
	real logy[N];
  real ry[N];
  for (j in 1:N) {
    logy[j] = log(y[j]+0.5);
    ry[j] = 1.0*y[j];
    }
  muy = log(mean(ry));
	sdy = sd(logy);
}

parameters {
	real delta[J+11];
	real theta0;
}

transformed parameters{
	vector[J+12] theta;
	theta[1] = 5*sdy*theta0 + muy;
	for (j in 1:(J+11)){
	  theta[j+1] = delta[j]*sqrt(duxvar1[j]) + theta[j];
	  }
}

model {
	theta0 ~ normal(0, 1);
	delta ~ normal(0, 1);
	for (i in 1:N){
	  y[i] ~ poisson_log(theta[xrank1[i]]);
	  }
}

generated quantities {
  vector[N] log_lik;
  vector[12] y_rep;
  for (i in 1:N) {
    log_lik[i] = poisson_log_lpmf(y[i] | theta[xrank1[i]]);
  }
  for (i in 1:12){
    y_rep[i] = poisson_rng(exp(theta[J+i]));
  }
}
