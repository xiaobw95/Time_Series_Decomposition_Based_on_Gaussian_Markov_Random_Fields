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
	real zdelta[J-1];
	real ztheta1;
	real <lower=0, upper=1> zgam;
	real <lower=0, upper=1> zsigma;
}
	  
transformed parameters{
	vector[J] theta;
	real <lower=0> gam;
	real <lower=0> sigma;
  sigma = 5.0*tan(zsigma*pi()/2);
	gam = 0.06*tan(zgam*pi()/2);
	theta[1] = 5*sdy*ztheta1 + muy;
	for (j in 1:(J-1)){
	  theta[j+1] = gam*zdelta[j]*sqrt(duxvar1[j]) + theta[j];
	  }
}

model {
  zsigma ~ uniform(0,1); 
	zgam ~ uniform(0, 1);
	ztheta1 ~ normal(0, 1);
	zdelta ~ normal(0, 1);
	for (i in 1:N){
	  y[i] ~ normal(theta[xrank1[i]], sigma); 
	  }
}
