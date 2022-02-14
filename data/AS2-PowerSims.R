m1<-10
m2<-15

sd1<-3
sd2<-3

n1<-10
n2<-10




x<-seq(-5,30 , 0.1)
p1<-dnorm(x , mean=m1 , sd=sd1)
p2<-dnorm(x , mean=m2 , sd=sd2)

plot(x,p1,type='l' , ylim=c(0,max(p1,p2)))
points(x,p2,type='l' , col='red')
abline(v=c(m1,m2) , col=c('black' , 'red') , lty=2)

#generate illustratie data set
set.seed(0)
dat1<-rnorm(n=n1 , mean = m1 , sd = sd1)
dat2<-rnorm(n=n2 , mean=m2 , sd = sd2)
boxplot(dat1,dat2)

nVals<-3:30
powerVals<-numeric(length(nVals))
for(iN in 1:length(nVals)){

  n1<-nVals[iN]
  n2<-nVals[iN]

  nSims<-1000
  pVals<-numeric(nSims)
  for(iSim in 1:nSims){
  
    dat1<-rnorm(n=n1 , mean = m1 , sd = sd1)
    dat2<-rnorm(n=n2 , mean=m2 , sd = sd2)
    
    pVals[iSim]<-t.test(dat1,dat2 , var.equal = TRUE)$p.value
  }
  powerVals[iN]<-length(which(pVals<0.05))/nSims
}

plot(nVals,powerVals)

#Q2 extract which sample size is minimum necessary for 80% power

#Q2 modify code to produce a plot for sd 3. How many samples do I now need for an 80% power

#Produce a plot for multiple different sds (2,3,5,10) and overlay

#Modify code to allow for diffent sds. g1 has sd 3 and g2 has sd 5.
#Need to use Welchs t-test

#Modify code to allow for different group sizes.
#Assume treatment group is 12. How many controls do I need for 90% power with diff in means of 10 and sd 8


#We can easily generalise this to a 1-way ANOVA with 


#Trick is data = model plus error

#Need to specify the model
#Need to specify the error

#y=b0+b1x

x<-seq(10,100,length=n)

