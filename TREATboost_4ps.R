#generalized boosted regression trees
library(readstata13)
treat=read.dta13("C:/Users/scottpw/Desktop/Consults/CollegeSummit/CA_TREATmine.dta")
#make sure data is right by checking Rows X Columns
dim(treat)
#call generalized boosting package in R (remember R requires one to load packages)
library(gbm)
#set random seed to insure exact consistency when rerunning procedure
set.seed(32438)
#run boosting algorithm (note one will have to train parameters to find best model)
boost.red=gbm(Treatment~.,data=treat,distribution="bernoulli", n.trees=5000, 
interaction.depth=5,shrinkage=.01,cv.folds=10, n.cores=2)
#find which predictors are most influential on outcome
summary(boost.red)
#create propensity scores
yhat=predict.gbm(boost.red,type="response",n.trees=5000)
psD=as.data.frame(yhat)
yobs=treat$Treatment
pred=ifelse(yhat>.5,1,0)
table(pred,yobs)
library(foreign)
write.dta(psD, "C:/Users/scottpw/Desktop/Consults/CollegeSummit/OH_ps.dta")
