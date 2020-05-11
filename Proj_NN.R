library(ggplot2)
library(tree)
install.packages("neuralnet")
library(corrplot)
install.packages("corrplot")
library(RColorBrewer)
library(Metrics)
install.packages("Metrics")
library(grid)
library(gridExtra)
library(dplyr)

setwd("C:\\Users\\nishi\\source\\repos\\Project_MSIS5223")
getwd()



Tornadoes_data1 = read.table("Tornadoes_SPC_1950to2015.csv", sep=",",header=TRUE)
Tornadoes_data2 = read.table("2018_torn_prelim.csv", sep=",",header=TRUE)
Tornadoes_data3 = read.table("2017_torn.csv", sep=",",header=TRUE)
Tornadoes_data4 = read.table("2016_torn.csv", sep=",",header=TRUE)




Tornadoes_data1 = Tornadoes_data1[c("om","yr","mo","dy",
                                    "tz","st","stf","stn","mag","inj","fat",
                                    "loss","closs","slat","slon","elat","elon","len","wid","fc")]



Tornadoes_data2 = Tornadoes_data2[c("om","yr","mo","dy",
                                    "tz","st","stf","stn","mag","inj","fat",
                                    "loss","closs","slat","slon","elat","elon","len","wid","fc")]



Tornadoes_data3 = Tornadoes_data3[c("om","yr","mo","dy",
                                    "tz","st","stf","stn","mag","inj","fat",
                                    "loss","closs","slat","slon","elat","elon","len","wid","fc")]



Tornadoes_data4 = Tornadoes_data4[c("om","yr","mo","dy",
                                    "tz","st","stf","stn","mag","inj","fat",
                                    "loss","closs","slat","slon","elat","elon","len","wid","fc")]
Tornadoes_data <- rbind(Tornadoes_data1,Tornadoes_data2,Tornadoes_data3,Tornadoes_data4)
Tornadoes_data
str(Tornadoes_data)

Tornadoes_data[sapply(Tornadoes_data, is.factor)] <- data.matrix(Tornadoes_data[sapply(Tornadoes_data, is.factor)])
Tornadoes_data
write.csv(Tornadoes_data,'Tornado_Data.csv', row.names = FALSE)

#correlation plot
corrplot(cor(Tornadoes_data),col=brewer.pal(n=8, name="RdYlBu"))


require(neuralnet)

# fit neural network
nn=neuralnet(loss~om+yr+mo+dy+tz+st+stf+stn+mag+inj+fat+closs+slat+slon+elat+elon+len+wid+fc,
             data=Tornadoes_data, hidden=3,act.fct = "logistic",
             linear.output = FALSE)
plot(nn)


# Random sampling
samplesize = 0.6 * nrow(Tornadoes_data)
set.seed(80)
index = sample( seq_len ( nrow ( Tornadoes_data ) ), size = samplesize )

# Create training and test set
datatrain = Tornadoes_data[ index, ]
datatest = Tornadoes_data[ -index, ]
max = apply(Tornadoes_data , 2 , max)
min = apply(Tornadoes_data, 2 , min)
scaled = as.data.frame(scale(Tornadoes_data, center = min, scale = max - min))
# creating training and test set
trainNN = scaled[index , ]
testNN = scaled[-index , ]

#Multivariate Model
mod1 <- lm(loss~om+yr+mo+dy+tz+st+stf+stn+mag+inj+fat+closs+slat+slon+elat+elon+len+wid+fc, data = trainNN)
mod1

# fit neural network - 3 hidden layers
set.seed(2)
nn1 = neuralnet(loss~om+yr+mo+dy+tz+st+stf+stn+mag+inj+fat+closs+slat+slon+elat+elon+len+wid+fc, trainNN, hidden = 3 , act.fct = "logistic", linear.output = T )
nn1$result.matrix
# plot neural network 
plot(nn1)

summary(nn1)
nn2 = neuralnet(loss~om+yr+mo+dy+tz+st+stf+stn+mag+inj+fat+closs+slat+slon+elat+elon+len+wid+fc, trainNN, hidden = c(5,3) ,act.fct = "logistic", linear.output = T )
nn2$result.matrix
# plot neural network
plot(nn2)

#RMSE, MSE, MAD for mod1
predictions <- predict(mod1, datatest)
rmse(datatest$loss, predictions)
mse(datatest$loss, predictions)
mae(datatest$loss, predictions)

#RMSE, MSE, MAD for NN1
predictions <- predict(nn1, datatest)
rmse(datatest$loss, predictions)
mse(datatest$loss, predictions)
mae(datatest$loss, predictions)

#RMSE, MSE, MAD for NN2
predictions <- predict(nn2, datatest)
rmse(datatest$loss, predictions)
mse(datatest$loss, predictions)
mae(datatest$loss, predictions)


# Model with activation function tanh
set.seed(2)
nn3 = neuralnet(loss~om+yr+mo+dy+tz+st+stf+stn+mag+inj+fat+closs+slat+slon+elat+elon+len+wid+fc, trainNN, hidden = c(5,3) , act.fct = "tanh", linear.output = T )
nn3$result.matrix
# plot neural network
plot(nn3)

#RMSE, MSE, MAD for NN3
predictions <- predict(nn3, datatest)
rmse(datatest$loss, predictions)
mse(datatest$loss, predictions)
mae(datatest$loss, predictions)

## Prediction using neural network nn1

predict_testNN = neuralnet::compute(nn1, testNN[,c(1:20)])
predict_testNN = (predict_testNN$net.result * (max(Tornadoes_data$loss) - min(Tornadoes_data$loss))) + min(Tornadoes_data$loss)

plot(datatest$loss, predict_testNN, col='blue', pch=16, ylab = "predicted loss NN1", xlab = "real loss")

abline(0,1)

RMSE.NN = (sum((datatest$loss - predict_testNN)^2) / nrow(datatest)) ^ 0.5
RMSE.NN
## Prediction using neural network nn2

predict_testNN = neuralnet::compute(nn2, testNN[,c(1:20)])
predict_testNN = (predict_testNN$net.result * (max(Tornadoes_data$loss) - min(Tornadoes_data$loss))) + min(Tornadoes_data$loss)

plot(datatest$loss, predict_testNN, col='blue', pch=16, ylab = "predicted loss NN", xlab = "real loss")

abline(0,1)


## Prediction using neural network nn3
predict_testNN = neuralnet::compute(nn3, testNN[,c(1:20)])
predict_testNN = (predict_testNN$net.result * (max(Tornadoes_data$loss) - min(Tornadoes_data$loss))) + min(Tornadoes_data$loss)

plot(datatest$loss, predict_testNN, col='blue', pch=16, ylab = "predicted loss NN3", xlab = "real loss")

abline(0,1)


#**************************
#Test the resulting output Classification
#temp_test <- subset(testNN, select = c("om","yr","mo","dy",
#                                       "tz","st","stf","stn","mag","inj","fat",
#                                       "closs","slat","slon","elat","elon","len","wid","fc"))
#head(temp_test)
#results <- neuralnet::compute(nn1, temp_test)
#nn.results <- compute(nn, temp_test)
#res <- data.frame(actual = testNN$loss, prediction = results$net.result)
#res
#roundedresults<-sapply(res,round,digits=0)
#roundedresultsdf=data.frame(roundedresults)
#attach(roundedresultsdf)
#table(actual,prediction)



#Test for Regression
#re <- data.frame(actual = testNN$loss, prediction = results$net.result)
#re

#Accuracy
#predicted=res$prediction * abs(diff(range(testNN$loss))) + min(testNN$loss)
#actual=res$actual * abs(diff(range(testNN$loss))) + min(testNN$loss)
#comparison=data.frame(predicted,actual)
#deviation=((actual-predicted)/actual)
#comparison=data.frame(predicted,actual,deviation)
#accuracy=1-abs(mean(deviation))
#accuracy



