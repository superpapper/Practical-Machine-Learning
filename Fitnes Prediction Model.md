---
title: "Fitness Data Prediction Model"
author: "superpapper"
date: "Saturday, March 21, 2015"
output: html_document
---

# Executive Summary
Using devices such as Jawbone Up, Nike FuelBand, and Fitbit it is now possible to collect a large amount of data about personal activity relatively inexpensively.The data for this project come from this source:[http://groupware.les.inf.puc-rio.br/har](http://groupware.les.inf.puc-rio.br/har). Data are collected from accelerometers on the belt, forearm, arm, and dumbell of 6 participants. They were asked to perform barbell lifts correctly and incorrectly in 5 different ways, assigned 'classes' A, B, C, D, E in the data set. This report is going to bulid a 'classes' prediction model based on the training set and then predict the classes for the test data set. 

This report use the following libraries:


```r
library(caret)
library(kernlab)
library(corrplot)
library(randomForest)
library(knitr)
```

#Data Prcossing
The training data for this project are available here: 
[https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv](https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv)

The test data are available here: 
[https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv](https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv)

download them to your working directory /data subfolder and read in with read.csv function. Then remove NAs and other identifier columns that are not useful for the model. Finally partition them with 70/30 ratio for model fitting and cross validation. 

```r
#Read in data
data_training <- read.csv("./data/pml-training.csv", na.strings= c("NA",""," "))

#remove columm contain NAs. and other identifier info not useful for prediction model
data_training1 <- data_training[,colSums(is.na(data_training))==0]
data_training2 <- data_training1[8:length(data_training1)]

#Create training and cross validation test set
set.seed(1000)
inTrain <- createDataPartition(y = data_training2$classe, p = 0.7, list = FALSE)
training <- data_training2[inTrain, ]
crossvalidate <- data_training2[-inTrain, ]
```
#Create the Model
We seclect random forest as the model because its high accuracy in fitting models.
Fit the training data set using all the variables as the predictors with random forest mothod. Model OOB error rate is less than 1% which means this model is pretty accurate

```r
model <- randomForest(classe ~ ., data = training)
model
```

```
## 
## Call:
##  randomForest(formula = classe ~ ., data = training) 
##                Type of random forest: classification
##                      Number of trees: 500
## No. of variables tried at each split: 7
## 
##         OOB estimate of  error rate: 0.55%
## Confusion matrix:
##      A    B    C    D    E class.error
## A 3902    3    0    0    1 0.001024066
## B   12 2643    3    0    0 0.005643341
## C    0   18 2377    1    0 0.007929883
## D    0    0   28 2220    4 0.014209591
## E    0    0    1    4 2520 0.001980198
```
#Cross validation
Cross validation shows that the model accuracy is 99% which again confirm the accuracy of this model.

```r
pCrossValidate <- predict(model, crossvalidate)
confusionMatrix(crossvalidate$classe, pCrossValidate)
```

```
## Confusion Matrix and Statistics
## 
##           Reference
## Prediction    A    B    C    D    E
##          A 1671    3    0    0    0
##          B    5 1133    1    0    0
##          C    0    6 1018    2    0
##          D    0    0   10  953    1
##          E    0    0    0    3 1079
## 
## Overall Statistics
##                                           
##                Accuracy : 0.9947          
##                  95% CI : (0.9925, 0.9964)
##     No Information Rate : 0.2848          
##     P-Value [Acc > NIR] : < 2.2e-16       
##                                           
##                   Kappa : 0.9933          
##  Mcnemar's Test P-Value : NA              
## 
## Statistics by Class:
## 
##                      Class: A Class: B Class: C Class: D Class: E
## Sensitivity            0.9970   0.9921   0.9893   0.9948   0.9991
## Specificity            0.9993   0.9987   0.9984   0.9978   0.9994
## Pos Pred Value         0.9982   0.9947   0.9922   0.9886   0.9972
## Neg Pred Value         0.9988   0.9981   0.9977   0.9990   0.9998
## Prevalence             0.2848   0.1941   0.1749   0.1628   0.1835
## Detection Rate         0.2839   0.1925   0.1730   0.1619   0.1833
## Detection Prevalence   0.2845   0.1935   0.1743   0.1638   0.1839
## Balanced Accuracy      0.9982   0.9954   0.9938   0.9963   0.9992
```

#Prediction
We read in the test data with read.csv, process the data removing NAs and other identifiers and predict the output classes with the model created above and get the final predictions.

```r
#read in the final test data and predict the class for the 20 inputs
data_test <- read.csv("./data/pml-testing.csv", na.strings= c("NA",""," "))
data_test1 <- data_test[,colSums(is.na(data_test))==0]
data_test2 <- data_test1[8:length(data_test1)]
predictTest <- predict(model, data_test2)
predictTest
```

```
##  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 
##  B  A  B  A  A  E  D  B  A  A  B  C  B  A  E  E  A  B  B  B 
## Levels: A B C D E
```

#Conclusion
Random forest mothod is used in this report to generate a model to predict exercise manners based on data collected on accelerometers. Model yields high accuracy of 99% with the abundance of data and final prediction based for twenty test set is provided.

