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
	real zdelta[J+11];
	real ztheta1;
	real <lower=0, upper=1> ztau2[J+11];
	real <lower=0, upper=1> zgam;
}

transformed parameters{
	vector[J+12] theta;
	real <lower=0> gam;
	vector[J+11] tau;
	gam = 0.06*tan(zgam*pi()/2);
	theta[1] = 5*sdy*ztheta1 + muy;
	for (j in 1:(J+11)){
	  tau[j] = gam*sqrt(-2*log(1-ztau2[j]));
	 	theta[j+1] = zdelta[j]*tau[j]*sqrt(duxvar1[j]) + theta[j];
	 	}
}

model {
	zgam ~ uniform(0, 1);
	ztau2 ~ uniform(0, 1);
	ztheta1 ~ normal(0, 1);
	zdelta ~ normal(0, 1);
	for (i in 1:N){
	  y[i] ~ poisson_log(theta[xrank1[i]]);
	  }
}

generated quantities {
  vector[N] log_lik;
  for (i in 1:N) {
    log_lik[i] = poisson_log_lpmf(y[i] | theta[xrank1[i]]);
  }
}
