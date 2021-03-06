#data input
load("~/Time_Series_Decomposition_Based_on_Gaussian_Markov_Random_Fields/data/TS.rda")
tts<-TS[1:150]

#data preparation for the first fitting
test<-list(J=150,y=tts)

test$N <- length(test$y)
test$xvar1 <- 1:test$N
uxv1 <- unique(test$xvar1)
ruxv1 <- rank(uxv1)
m.xv <- cbind(1:length(uxv1), uxv1, ruxv1)
m.xv <- m.xv[order(m.xv[,2]),]
duxv1 <- rep(1,149)
suxv1 <- sort(uxv1)
rnk.xv <- integer(test$N)
for (ii in 1:test$N){
  rnk.xv[ii] <- ruxv1[which(uxv1==test$xvar1[ii])]
}
test$J <- length(uxv1)
test$duxvar1 <- duxv1
test$xrank1 <- rnk.xv

tmp.dat <<- test

#MCMC settings
nchain <- 4
ntotsamp <- 2500
nthin <- 5
nburn <- 1500
niter <- (ntotsamp/nchain)*nthin + nburn

#first fitting with different priors
#Gaussian prior
library(rstan)
TT<-stan('src/stan/Gaussian.stan', data=test, chains=nchain, iter=niter, warmup=nburn, thin=nthin,
         control=list(adapt_delta=0.95, max_treedepth=12))
#Laplace prior
TTL<-stan('src/stan/Laplace.stan', data=test, chains=nchain, iter=niter, warmup=nburn, thin=nthin,
          control=list(adapt_delta=0.95, max_treedepth=12))
#Horseshoe prior
TTH<-stan('src/stan/Horseshoe.stan', data=test, chains=nchain, iter=niter, warmup=nburn, thin=nthin,
          control=list(adapt_delta=0.95, max_treedepth=12))

TT.N<-matrix(unlist(extract(TTL,pars=c("theta"))),nrow = 2500, byrow = FALSE)
TT.N<-exp(TT.N)
theta<-apply(TT.N,2,median)
mean((theta[151:162]-TS[151:162])^2)


#extract seasonal component
temp=c()
for (i in 1:12){temp=c(temp,rep(mean(theta[1:150][(1+12*(i-1)):(12+12*(i-1))]),12))}
temp=c(temp,rep(mean(theta[145:150]),6))
temp=test$y-temp
seasonal<-c()
for (i in 1:12){seasonal<-c(seasonal,mean(temp[seq(i,150,12)]))}
seasonal<-rep(seasonal,length=150)
test1 <- list(J = 150, y = test$y-seasonal)

#data preparation for the second fitting
test1$N <- length(test1$y)
test1$xvar1 <- 1:test1$N
uxv1 <- unique(test1$xvar1)
ruxv1 <- rank(uxv1)
m.xv <- cbind(1:length(uxv1), uxv1, ruxv1)
m.xv <- m.xv[order(m.xv[,2]),]
duxv1 <- diff(m.xv[,2])
suxv1 <- sort(uxv1)
rnk.xv <- integer(test1$N)
for (ii in 1:test1$N){
  rnk.xv[ii] <- ruxv1[which(uxv1==test1$xvar1[ii])]
}
test1$J <- length(uxv1)
test1$duxvar1 <- duxv1
test1$xrank1 <- rnk.xv

tmp.dat <<- test1


# #second fitting with Gaussian prior
# TT1<-stan('src/stan/Gaussian1.stan', data=test1, chains=nchain, iter=niter, warmup=nburn, thin=nthin,
#          control=list(adapt_delta=0.95, max_treedepth=12))
# TT2<-stan('src/stan/Laplace1.stan', data=test1, chains=nchain, iter=niter, warmup=nburn, thin=nthin,
#           control=list(adapt_delta=0.95, max_treedepth=12))
# TT3<-stan('src/stan/Horseshoe1.stan', data=test1, chains=nchain, iter=niter, warmup=nburn, thin=nthin,
#           control=list(adapt_delta=0.95, max_treedepth=12))

# second fitting and forecasting
TTp<-stan('src/stan/Gaussian_forecast.stan', data=test1, chains=nchain, iter=niter, warmup=nburn, thin=nthin,
                    control=list(adapt_delta=0.99, max_treedepth=20))
TT.N1<-matrix(unlist(extract(TTp,pars=c("theta"))),nrow = 2500, byrow = FALSE)
theta1<-apply(TT.N1,2,median)
mean((theta1[151:162]+seasonal[139:150]-TS[151:162])^2)

#extract trend component
trend=theta1[1:150]
random=tts-seasonal-trend


#plot of time series decomposition
par(mfrow=c(1,3), mar=c(2,1.5,1.5,1), oma=c(2,2,0,0))
plot(trend,type='l')
par(mfrow=c(3,1), mar=c(2,1.5,1.5,1), oma=c(2,2,0,0))
plot(trend,type='l')
plot(seasonal,type='l')
plot(random,type='l')

# #step width chosed by cross validation
# step_width<-select_StepLength(trend,seasonal,random)
#
# #mse of forcasting based on linear extension
# mean((predict(lm(y~.,data=data.frame(y=trend[(150-step_width+1):150],x=c((150-step_width+1):150))),newdata=data.frame(x=c(151:162)))+seasonal[139:150]-TS[151:162])^2)
#
#
# #use B-spline to fit trend line
# library(splines)
# tr<-data.frame(y=trend,x=1:150)
# loocv<-c()
# for (i in 3:10){
#   cv<-c()
#   for (j in 1:150){
#     temp<-tr[-j,]
#     long_line<-lm(y~bs(x,df=i),data=temp)
#     cv<-c(cv,abs(predict(long_line,newdata=data.frame(x=j))-trend[j]))
#   }
#   loocv<-c(loocv,mean(cv))
# }
# long_line<-lm(y~bs(x,df=which.min(loocv)+2),data=tr)
# mean((seasonal[139:150]+predict(long_line,newdata = data.frame(x=c(151:162)))-TS[151:162])^2)
#
# #use SVM to fit trend line
# library(e1071)
# modelsvm = svm(trend~x,data=data.frame(trend=trend,x=c(1:150)))
# predYsvm = predict(modelsvm, newdata=data.frame(x=c(151:162)))
# mean((predYsvm+seasonal[139:150]-TS[151:162])^2)

#time series decomposition based on ARIMA
library(forecast)
plot(decompose(TS))
arim <- auto.arima(ts(tts,start=c(2004,1),frequency=12),stepwise=FALSE,approximation=FALSE)
ari<-forecast(arim,h=12)
mean((ari$mean-TS[151:162])^2)


#results from RNN/LSTM
load("/src/Python/prediction-rnn.rda")
mean((rnn-TS[151:162])^2)

#results from Prophet
library(prophet)
ph<-prophet(data.frame(y=tts, ds=seq(ISOdate(2004,1,1), by = "month", length.out = 150)))
pfuture <- make_future_dataframe(ph, periods = 12)
pforecast <- predict(ph, pfuture)
mean((pforecast$yhat[151:162]-TS[151:162])^2)
prophet_plot_components(ph, pforecast)

#comparison
plot(c(151:162),TS[151:162],ylim=c(10,75),type='l',main='Performance of prediction',xlab='time',ylab='count')
par(new=TRUE)
plot(c(151:162),ari$mean,ylim=c(10,75),col=2,type='l',main='Performance of prediction',xlab='time',ylab='count')
par(new=TRUE)
plot(c(151:162),rnn,ylim=c(10,75),col=3,type='l',main='Performance of prediction',xlab='time',ylab='count')
par(new=TRUE)
plot(c(151:162),pforecast$yhat[151:162],ylim=c(10,75),col=4,type='l',main='Performance of prediction',xlab='time',ylab='count')
par(new=TRUE)
plot(c(151:162),theta1[151:162]+seasonal[139:150],ylim=c(10,75),col=5,type='l',main='Performance of prediction',xlab='time',ylab='count')
legend('topright', legend=c('Observation','AUTO-ARIMA','RNN/LSTM','Prophet','GMRF'), col=c(1:5), lty=1, cex=0.8)
