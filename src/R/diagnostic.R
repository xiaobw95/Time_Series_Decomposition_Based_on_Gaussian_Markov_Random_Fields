#first fitting
check_hmc_diagnostics(TT)
check_hmc_diagnostics(TTL)
check_hmc_diagnostics(TTH)

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

traceplot(TTL,pars=c('theta[1]'))
plot(TTL, plotfun = "rhat")
plot(TTL, plotfun = "ess")

plot_trend1(theta=extract_theta(TTL,obstype='poisson'),
            obstype="poisson", obsvar=TS, xvar=1:162,
            main="first GMRF fitting", xlab="time", ylab="count")

#second fitting
check_hmc_diagnostics(TT1)
check_hmc_diagnostics(TT2)
check_hmc_diagnostics(TT3)

log_lik_4 <- extract_log_lik(TT1)
log_lik_5 <- extract_log_lik(TT2)
log_lik_6 <- extract_log_lik(TT3)
loo4 <- loo(log_lik_4)
loo5 <- loo(log_lik_5)
loo6 <- loo(log_lik_6)
compare(loo4,loo5,loo6)

waic4<-waic(log_lik_4)
waic5<-waic(log_lik_5)
waic6<-waic(log_lik_6)
compare(waic4,waic5,waic6)

traceplot(TT1,pars=c('theta[1]'))
traceplot(TT1,pars=c('sigma'))
plot(TT1, plotfun = "rhat")
plot(TT1, plotfun = "ess")

plot_trend1(theta=extract_theta(TT1,obstype='normal'),
            obstype="normal", obsvar=TS, xvar=1:150,
            main="second GMRF fitting", xlab="time", ylab="count")
