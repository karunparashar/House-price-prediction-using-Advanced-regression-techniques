rm(list = ls())
training = read.csv('train.csv',header = TRUE)
testing = read.csv('test.csv',header = TRUE)
head(training)
library(tidyverse)
library(caret)
nafree_train=training
glimpse(nafree_train)
library(tidyverse)
library(GGally)
install.packages("sqldf")

head(nafree_train)
summary(nafree_train$GarageYrBlt)


for (i in c(1:80)){
  if (sum(is.na(nafree_train[i]))>0){
    if(is.factor(nafree_train[,i]) == TRUE){  
      nafree_train[,i] = addNA(nafree_train[,i])
      levels(nafree_train[,i])[is.na(levels(nafree_train[,i]))] <- "NA"
    }
    else{
      nafree_train[,i][is.na(nafree_train[,i])]  = mean(nafree_train[,i],na.rm = TRUE)
    }
  }
  else{
    NULL
  }
} 
warnings()
#checking the levels and the length for data pre and post imputation
###################################
levels(nafree_train$Alley)
length(levels(nafree_train$Alley))
length(levels(training$Alley))
sum(is.na(training$Alley))
sum(is.na(nafree_train$Alley))
###################################

str(nafree_train)

set.seed(123)
smp = sample(1:nrow(nafree_train),nrow(nafree_train)/5)
tr_data = nafree_train[-smp,]
test_data = nafree_train[smp,]



###########################################
#Random Forest
###########################################
library(randomForest)
model_rf <- train(SalePrice ~., data = tr_data, method = "rf",
               trControl = trainControl("cv", number = 10))
predrf <- model_rf %>% predict(test_data)
mse_rf = mean((abs(predrf-test_data$SalePrice))^2)
rmse_rf = sqrt(mse_rf)

sapply(tr_data, class)
sapply(test_data, class)

gbm

###########################################
#Gradient Boosting
###########################################
library(xgboost)
set.seed(123)
model <- train(SalePrice ~., data = tr_data, method = "xgbTree",
               trControl = trainControl("cv", number = 10))
predXGB <- model %>% predict(test_data)
mse_xgb = mean((abs(predXGB-test_data$SalePrice))^2)
rmse_xgb = sqrt(mse_xgb)


###########################################
#Deep Neural networks
###########################################

set.seed(123)
model_nn <- train(SalePrice ~., data = tr_data, method = "dnn",
               trControl = trainControl("cv", number = 10))
pred_nn <- model_nn %>% predict(test_data)
mse_nn = mean((abs(pred_nn-test_data$SalePrice))^2)
rmse_nn = sqrt(mse_nn)

###########################################
#GBM
###########################################
library(randomForest)
set.seed(7)
model_gbm <- train(SalePrice ~., data = tr_data, method = "gbm",
                  trControl = trainControl("cv", number = 10))
predgbm <- model_gbm %>% predict(test_data)
mse_gbm = mean((abs(predgbm-test_data$SalePrice))^2)
rmse_gbm = sqrt(mse_gbm)


###########################################
#Gradient Boosting on test data
###########################################
summary(nafree_train)
summary(testing)
testing$MSZoning[is.na(testing$MSZoning)] = 'RL'
testing$Utilities[is.na(testing$Utilities)] = 'AllPub'
testing$Exterior1st[is.na(testing$Exterior1st)] = 'VinylSd'
testing$Exterior2nd[is.na(testing$Exterior2nd)] = 'VinylSd'
testing$KitchenQual[is.na(testing$KitchenQual)] = 'TA'
testing$Functional[is.na(testing$Functional)] = 'Typ'
testing$SaleType[is.na(testing$SaleType)] = 'WD'

for (i in c(1:80)){
  if (sum(is.na(testing[i]))>0){
    if(is.factor(testing[,i]) == TRUE){  
      testing[,i] = addNA(testing[,i])
      levels(testing[,i])[is.na(levels(testing[,i]))] <- "NA"
    }
    else{
      testing[,i][is.na(testing[,i])]  = mean(testing[,i],na.rm = TRUE)
    }
  }
  else{
    NULL
  }
} 
library(xgboost)

set.seed(123)
model_test <- train(SalePrice ~., data = nafree_train, method = "xgbTree",
               trControl = trainControl("repeatedcv", repeats =  5))


predXGB_test = predict(model_test,testing)
predXGB_test = as.data.frame(predXGB_test)
final = cbind(c(1:1459),predXGB_test)
names(final) = c("Id","SalePrice")
write.csv(final, file = "predicted_data.csv")




