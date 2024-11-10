#generalized boosted regression trees
#pull data in from Stata (make sure in Stat 11/12 by using 'saveold' command in Stata)
library(readstata13)
FAFSA3=read.dta13("C:/Users/scottpw/Desktop/Consults/CollegeSummit/CA_FAFSAmine.dta")
#make sure data is right by checking Rows X Columns
dim(FAFSA3)
#call generalized boosting package in R (remember R requires one to load packages)
library(gbm)
#set random seed to insure exact consistency when rerunning procedure
set.seed(3769)
#make a training data set
train=sample(1:nrow(FAFSA3),nrow(FAFSA3)/2)
#make a testing dataset to determine predictive power
test=(-train)

#run boosting algorithm (note one will have to train parameters to find best model)
boost.red=gbm(FAFSA_3_3_17~.,data=FAFSA3[train,],distribution="poisson",n.trees=5000,
interaction.depth=5,cv.folds=10,shrinkage=.01, n.cores=2)
#find which predictors are most influential on outcome
summary(boost.red)
#create predicted values (in case of logistic these are propensity scores)
yhat=predict.gbm(boost.red,newdata=FAFSA3[test,],n.trees =5000, type="response")
#determine preditive error
yobs=FAFSA3[test,"FAFSA_3_3_17"]
mean((yobs-yhat)^2)
mean(abs(yobs-yhat))
