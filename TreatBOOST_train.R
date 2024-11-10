#generalized boosted regression trees
#pull data in from Stata (make sure in Stat 11/12 by using 'saveold' command in Stata)
library(readstata13)
TREAT=read.dta13("C:/Users/scottpw/Desktop/Consults/CollegeSummit/CA_TREATmine.dta")
#make sure data is right by checking Rows X Columns
dim(TREAT)
#call generalized boosting package in R (remember R requires one to load packages)
library(gbm)
#set random seed to insure exact consistency when rerunning procedure
set.seed(3769)
#make a training data set
train=sample(1:nrow(TREAT),nrow(TREAT/2))
#make a testing dataset to determine predictive power
test=(-train)

#run boosting algorithm (note one will have to train parameters to find best model)
boost.red=gbm(Treatment~.,data=TREAT[train,],distribution="bernoulli",n.trees=5000,
interaction.depth=5,cv.folds=10,shrinkage=.01, n.cores=2)
#find which predictors are most influential on outcome
summary(boost.red)
yhat=predict.gbm(boost.red,newdata=TREAT[test,],type="response",n.trees=5000)
psD=as.data.frame(yhat)
yobs=TREAT[test,"Treatment"]
pred=ifelse(yhat>.5,1,0)
table(pred,yobs)
