check_hmc_diagnostics(TT)
check_hmc_diagnostics(TT1)
check_hmc_diagnostics(TTL)
check_hmc_diagnostics(TTH)

traceplot(TT,pars=c('theta[1]'))
plot(TT,pars=c('theta'))
plot(TT, plotfun = "rhat")

library("loo")
log_lik_1 <- extract_log_lik(TT)
log_lik_2 <- extract_log_lik(TTL)
log_lik_3 <- extract_log_lik(TTH)
loo1 <- loo(log_lik_1)
loo2 <- loo(log_lik_2)
loo3 <- loo(log_lik_3)
compare(loo1,loo2,loo3)

lpd_point <- cbind(
  loo1$pointwise[,"elpd_loo"],
  loo2$pointwise[,"elpd_loo"],
  loo3$pointwise[,"elpd_loo"]
)
(stacking_wts <- stacking_weights(lpd_point))

waic1<-waic(log_lik_1)
waic2<-waic(log_lik_2)
waic3<-waic(log_lik_3)
compare(waic1,waic2,waic3)
