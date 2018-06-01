functions{
  real hs_prior_lp(real r1_global, real r2_global, real r1_local, real r2_local) {
    r1_global ~ normal(0.0, 1.0);
    r2_global ~ inv_gamma(0.5, 0.5);

    r1_local ~ normal(0.0, 1.0);
    r2_local ~ inv_gamma(0.5, 0.5);

    return (r1_global * sqrt(r2_global)) * r1_local * sqrt(r2_local);
  }
}

data {
  int<lower=0> N; // number of observations
	int<lower=0> J; // number of grid cells
  vector [N] xvar1;  //locations for observations
  vector [J-1] duxvar1;  //distances between unique locations
  int<lower=0> xrank1[N]; //rank order of location for each obs
  int <lower=0> y[N];  // response for obs i
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
	real delta_raw[J-1];
	real theta0;
	real<lower=0> tau_s1;
  real<lower=0> tau_s2;
  real<lower=0> tau1;
  real<lower=0> tau2;
}

transformed parameters{
	vector[J] theta;
	real delta[J-1];
	theta[1] = 5*sdy*theta0 + muy;
	for (j in 1:(J-1)){
	  delta[j] = hs_prior_lp(tau_s1, tau_s2, tau1, tau2) * delta_raw[j];
	  }
	for (j in 1:(J-1)){
	 	theta[j+1] = delta[j]*sqrt(duxvar1[j]) + theta[j];
	 	}
}

model {
	theta0 ~ normal(0, 1);
	delta_raw ~ normal(0, 1);
	for (i in 1:N){
	  y[i] ~ poisson_log_lpmf(theta[xrank1[i]]);
	  }
}

generated quantities {
  vector[N] log_lik;
  for (i in 1:N) {
    log_lik[i] = poisson_log_lpmf(y[i] | theta[xrank1[i]]);
  }
}

