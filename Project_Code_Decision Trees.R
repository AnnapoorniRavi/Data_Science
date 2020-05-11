install.packages("psych")
install.packages("ggplot2")
install.packages("tree")
install.packages("Hmisc")

library(foreign)
library(psych)
library(ggplot2)
library(tree)
library(Hmisc)

options(digits=4)   #Useability by way of rounding
library(forecast)

setwd("C:\\Users\\Sahi\\OneDrive\\MSIS 5223\\Project\\Dataset")
getwd()

Tornadoes_data1 = read.table("Tornadoes_SPC_1950to2015.csv", sep=",",header=TRUE)
Tornadoes_data2 = read.table("2018_torn_prelim.csv", sep=",",header=TRUE)
Tornadoes_data3 = read.table("2017_torn.csv", sep=",",header=TRUE)
Tornadoes_data4 = read.table("2016_torn.csv", sep=",",header=TRUE)


Tornadoes_data1 = Tornadoes_data1[c("om","yr","mo","dy",
                                    "tz","stf","stn","mag","inj","fat",
                                    "loss","closs","slat","slon","elat","elon","len","wid","fc")]

Tornadoes_data2 = Tornadoes_data2[c("om","yr","mo","dy",
                                    "tz","stf","stn","mag","inj","fat",
                                    "loss","closs","slat","slon","elat","elon","len","wid","fc")]

Tornadoes_data3 = Tornadoes_data3[c("om","yr","mo","dy",
                                    "tz","stf","stn","mag","inj","fat",
                                    "loss","closs","slat","slon","elat","elon","len","wid","fc")]

Tornadoes_data4 = Tornadoes_data4[c("om","yr","mo","dy",
                                    "tz","stf","stn","mag","inj","fat",
                                    "loss","closs","slat","slon","elat","elon","len","wid","fc")]


Tornadoes_data <- rbind(Tornadoes_data1,Tornadoes_data2,Tornadoes_data3,Tornadoes_data4)

str(Tornadoes_data)

Tornadoes_data.pca = Tornadoes_data[c("om","yr","mo","dy",
                                      "tz","stf","stn","mag","inj","fat",
                                      "loss","closs","slat","slon","elat","elon","len","wid","fc")]


pcamodel_Tornadoes_data = princomp(na.omit(Tornadoes_data.pca), cor = FALSE)

plot(pcamodel_Tornadoes_data,main="Perceived Usefuleness Scree Plot")							#screeplot
biplot(pcamodel_Tornadoes_data)

Tornadoes_data.FA = factanal(~om+yr+mo+dy+tz+stf+
                               stn+mag+inj+fat+loss+closs+
                               slat+slon+elat+elon+len+wid+fc,
                             factors=2,
                             rotation="varimax",
                             scores="none",
                             data=Tornadoes_data)

Tornadoes_data.FA

Tornadoes_data[sapply(Tornadoes_data, is.factor)] <- data.matrix(Tornadoes_data[sapply(Tornadoes_data, is.factor)])

##Multiple Regression

mreg = lm(Tornadoes_data$loss~Tornadoes_data$om+Tornadoes_data$yr+Tornadoes_data$mo+Tornadoes_data$dy+Tornadoes_data$date+
            Tornadoes_data$tz+Tornadoes_data$stf+Tornadoes_data$stn+Tornadoes_data$mag+Tornadoes_data$inj+Tornadoes_data$fat
          +Tornadoes_data$closs+Tornadoes_data$slat+Tornadoes_data$slon+Tornadoes_data$elat+Tornadoes_data$elon+Tornadoes_data$len+Tornadoes_data$wid+Tornadoes_data$fc)
summary(mreg)

##Stepwise Regression 

sreg = step(lm(loss~om+yr+mo+dy+tz+stf+stn+mag+inj+fat+closs+slat+slon+elat+elon+len+wid+fc,data=Tornadoes_data),direction="both")

##Classification Using Decision Trees

Tornadoes_tree = tree(Tornadoes_data)
Tornadoes_tree

low = (Tornadoes_data$yr<63232)			#use the first split value of 63232
tapply(Tornadoes_data$closs, low, mean)
plot(Tornadoes_data$yr, Tornadoes_data$fat, pch=16)
abline(v=63232, lty=2)
lines(c(0,63232), c(24.92, 24.92))				#Low-end mean
lines(c(63232,max(Tornadoes_data$yr)), c(67,67))	#High-end mean
plot(Tornadoes_tree)					#plot the tree structure
text(Tornadoes_tree)					#attach text to tree plot

(Tornadoes_tree = tree(loss~., Tornadoes_data, mindev=1e-6, minsize=2))

plot(Tornadoes_tree)
text(Tornadoes_tree)





