oneSim <- function(n = 100, scen = "a") {
  if(scen == "a") {
    f <- function(x){2*x}
  } else if(scen == "b") {
    f <- function(x){sin(10*x)}
  }
  x <- sort(runif(n))
  y <- f(x) + rnorm(n)


  # Polynomial Models
  yh3 <- lm(y~poly(x,3))$fitted.values

  # Ndaraya-Watson Models
  h <- n^(-1/5)
  yh6 <- ksmooth(x, y, kernel = "box", bandwidth = h)$y
  yh7 <- ksmooth(x, y, kernel = "normal", bandwidth = h)$y

  # Markov Random Fields with Shrinkage Priors
  test<-list(J=n,y=y)
  test$N <- length(test$y)
  test$xvar1 <- 1:test$N
  uxv1 <- unique(test$xvar1)
  ruxv1 <- rank(uxv1)
  m.xv <- cbind(1:length(uxv1), uxv1, ruxv1)
  m.xv <- m.xv[order(m.xv[,2]),]
  duxv1 <- diff(m.xv[,2])
  suxv1 <- sort(uxv1)
  rnk.xv <- integer(test$N)
  for (ii in 1:test$N){
    rnk.xv[ii] <- ruxv1[which(uxv1==test$xvar1[ii])]
  }
  test$J <- length(uxv1)
  test$duxvar1 <- duxv1
  test$xrank1 <- rnk.xv
  TT<-stan('src/stan/Gaussian1.stan', data=test, chains=nchain, iter=niter, warmup=nburn, thin=nthin,
           control=list(adapt_delta=0.95, max_treedepth=12))
  yh8 <- matrix(unlist(extract(TT,pars=c("theta"))),nrow = 2500, byrow = FALSE)
  yh8 <- apply(yh8,2,median)

  mse <- colMeans( (cbind(yh3,yh6,yh7,yh8) - f(x))^2 )
  names(mse) <- c("Poly Deg: 3", "NW-Box","NW-Gaussian","GMRF")
  mse
}

multipleSim <- function(n = 100, scen = "a", nsim = 10) {
  set.seed(1)
  all.mse <- replicate(nsim, oneSim(n, scen))
  apply(all.mse, 1, mean)
}

n.seq <- seq(100, 500, by = 100)

# Simulation Results A
simA <- sapply(n.seq, FUN = multipleSim, scen = "a", nsim = 10)
resA <- data.frame("MSE" = as.numeric(simA),
                   "Method" = rep(rownames(simA), 10),
                   "n" = rep(n.seq, each = 4),
                   "Scenario" = rep("Scenario a", 40))

# Simulation Results B
simB <- sapply(n.seq, FUN = multipleSim, scen = "b", nsim = 10)
resB <- data.frame("MSE" = as.numeric(simB),
                   "Method" = rep(rownames(simB), 10),
                   "n" = rep(n.seq, each = 4),
                   "Scenario" = rep("Scenario b", 40))

library(ggplot2)
dat <- rbind(resA, resB)
ggplot(dat, mapping = aes(x = n, y = MSE, color = Method)) +
  geom_line() + facet_wrap(~Scenario, scales = "free") + scale_y_log10()
