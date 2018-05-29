check_hmc_diagnostics(TT)
check_hmc_diagnostics(TT1)
check_hmc_diagnostics(TTL)
check_hmc_diagnostics(TTH)

traceplot(TT,pars=c('theta[1]'))
plot(TT,pars=c('theta'))
plot(TT, plotfun = "rhat")

plot_trend1(theta=extract_theta(TT,obstype='poisson'),
            obstype="poisson", obsvar=TS, xvar=1:162,
            main="first GMRF fitting", xlab="time", ylab="count")

library("loo")
log_lik_1 <- extract_log_lik(TT)
log_lik_2 <- extract_log_lik(TTL)
log_lik_3 <- extract_log_lik(TTH)
loo1 <- loo(log_lik_1)
loo2 <- loo(log_lik_2)
loo3 <- loo(log_lik_3)
compare(loo1,loo2,loo3)


waic1<-waic(log_lik_1)
waic2<-waic(log_lik_2)
waic3<-waic(log_lik_3)
compare(waic1,waic2,waic3)
