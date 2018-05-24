select_StepLength<-function(trend,seasonal,random,forcast=12){
  l=length(trend)
  cv=c()
  for (i in 1:as.integer(3*forcast)){
    temp=c()
    for (j in 1:(l-i-12+1)){
      lmodel<-lm(y~x,data=data.frame(y=trend[j:(i+j-1)],x=c(j:(i+j-1))))
      y_rep<-predict(lmodel,newdata=data.frame(x=(i+j):(i+j+11)))
      temp=c(temp,mean((y_rep-(trend[(i+j):(i+j+11)]+random[(i+j):(i+j+11)]))^2))
    }
    cv=c(cv,mean(temp))
  }
  return(as.integer(0.2*forcast)+which.min(cv)-1)
}

select_StepLength(trend,seasonal,random)
