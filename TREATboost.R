#generalized boosted regression trees
#pull data in from Stata (make sure in Stat 11/12 by using 'saveold' command in Stata)
library(foreign)
treat=read.dta("C:/Users/scottpw/Desktop/Consults/CollegeSummit/SCdat_boostR_treat.dta")
#make sure data is right by checking Rows X Columns
dim(treat)
#call generalized boosting package in R (remember R requires one to load packages)
library(gbm)
#set random seed to insure exact consistency when rerunning procedure
set.seed(32438)
#make a training data set
#train=sample(1:nrow(treat),nrow(treat)/2)
#make a testing dataset to determine predictive power
#test=(-train)
#run boosting algorithm (note one will have to train parameters to find best model)
boost.red=gbm(Treatment~.,data=treat,distribution="bernoulli",n.trees=5000,
interaction.depth=1,cv.folds=10,shrinkage=.01)
#find which predictors are most influential on outcome
summary(boost.red)
#create predicted value
yhat=predict.gbm(boost.red,newdata=treat,n.trees =5000,type="response")
pred=ifelse(yhat>.5,1,0)
table(pred,yobs)
#determine preditive error
yobs=treat$Treatment


err=boost.red$cv.error
err
#display predicted values
#yhat.boost
#boost.test
#psD=as.data.frame(ps)
#write.dta(psD, "C:/Users/scottpw/Desktop/Consult/CollegeSummit/psTr.dta")
