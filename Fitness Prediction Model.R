#Coursera Practical Machine Learning Project
# Using devices such as Jawbone Up, Nike FuelBand, and Fitbit it is now possible to collect a large amount of data about personal activity relatively inexpensively. These type of devices are part of the quantified self movement - a group of enthusiasts who take measurements about themselves regularly to improve their health, to find patterns in their behavior, or because they are tech geeks. One thing that people regularly do is quantify how much of a particular activity they do, but they rarely quantify how well they do it. In this project, your goal will be to use data from accelerometers on the belt, forearm, arm, and dumbell of 6 participants. They were asked to perform barbell lifts correctly and incorrectly in 5 different ways. More information is available from the website here: http://groupware.les.inf.puc-rio.br/har (see the section on the Weight Lifting Exercise Dataset). 

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

# plot a correlation matrix
M <- cor(training[,-length(training)])
corrplot(M,type="lower",method="pie",tl.cex=0.7)

# fit a model to predict the classe using everything else as a predictor
# fitting model show <1% error rate
model <- randomForest(classe ~ ., data = training)
model

# crossvalidate the model using the remaining 30% of data
# Cross validation show 99% accuracy
pCrossValidate <- predict(model, crossvalidate)
confusionMatrix(crossvalidate$classe, pCrossValidate)

#read in the final test data and predict the class for the 20 inputs
data_test <- read.csv("./data/pml-testing.csv", na.strings= c("NA",""," "))
data_test1 <- data_test[,colSums(is.na(data_test))==0]
data_test2 <- data_test1[8:length(data_test1)]
predictTest <- predict(model, data_test2)
predictTest
