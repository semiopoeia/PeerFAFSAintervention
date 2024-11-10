#generalized boosted regression trees
#pull data in from Stata (make sure in Stat 11/12 by using 'saveold' command in Stata)
library(readstata13)
FAFSAmo=read.dta13("C:/Users/scottpw/Desktop/Consults/CollegeSummit/MO_FAFSA_mine.dta")
#make sure data is right by checking Rows X Columns
dim(FAFSAmo)
#call generalized boosting package in R (remember R requires one to load packages)
library(gbm)
#set random seed to insure exact consistency when rerunning procedure
set.seed(3769)

#run boosting algorithm (note one will have to train parameters to find best model)
#since this is more of an explanatory process on one data set, we overfit
boost.red=gbm(FAFSA_3_3_17~.,data=FAFSAmo,distribution="poisson",n.trees=5000,
interaction.depth=5,cv.folds=10,shrinkage=.15)
#find which predictors are most influential on outcome
summary(boost.red)
#create predicted values
yhat=predict.gbm(boost.red,newdata=FAFSAmo,n.trees =5000, type="response")
#determine preditive error
yobs=FAFSAmo$FAFSA_3_3_17
mean(abs(yobs-yhat))

