#generalized boosted regression trees
#pull data in from Stata (make sure in Stat 11/12 by using 'saveold' command in Stata)
library(readstata13)
FAFSA=read.dta13("C:/Users/pws5/Documents/CA_toMine_FAFSA.dta")
#make sure data is right by checking Rows X Columns
dim(FAFSA)
#call generalized boosting package in R
library(gbm)
#set random seed to insure exact consistency when rerunning procedure
set.seed(3769)

#run boosting algorithm (note one will have to train parameters to find best model)
#since this is more of an explanatory process on one data set, we overfit
boost.red=gbm(FAFSA_5_18~.,data=FAFSA,distribution="poisson",n.trees=5000,
interaction.depth=1,cv.folds=10,shrinkage=.01)
#find which predictors are most influential on outcome
summary(boost.red)
#create predicted values
yhat=predict.gbm(boost.red,newdata=FAFSA,n.trees =5000, type="response")
#determine preditive error
yobs=FAFSA$FAFSA_5_18
mean(abs(yobs-yhat))

