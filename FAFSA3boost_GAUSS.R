#generalized boosted regression trees
#pull data in from Stata (make sure in Stat 11/12 by using 'saveold' command in Stata)
library(foreign)
FAFSA3=read.dta("C:/Users/scottpw/Desktop/Consults/CollegeSummit/SCdata_boost4R_FAFSA_by_March.dta")
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

#5000 trees, interaction=1, shrinkage=0.1
#run boosting algorithm (note one will have to train parameters to find best model)
boost.red=gbm(FAFSA_3_1_17~.,data=FAFSA3[train,],distribution="gaussian",n.trees=5000,
interaction.depth=1,cv.folds=10,shrinkage=.01)
#find which predictors are most influential on outcome
summary(boost.red)
#create predicted values (in case of logistic these are propensity scores)
yhat=predict.gbm(boost.red,newdata=FAFSA3[-train ,],n.trees =5000)
#determine preditive error
yobs=FAFSA3[-train,"FAFSA_3_1_17"]
mean((yobs-yhat)^2)
mean(abs(yobs-yhat))
