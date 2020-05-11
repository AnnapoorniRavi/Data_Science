library(ggplot2)
library(tree)
###install.packages('IDPmisc')
library(IDPmisc)
##install.packages('caTools')
##install.packages('randomForest')
library(caTools)
library(randomForest)

setwd("C:\\Priyanka_Spring2020\\R_Python")
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

nrow(Tornadoes_data1)
nrow(Tornadoes_data2)
nrow(Tornadoes_data3)
nrow(Tornadoes_data4)


Tornadoes_data <- rbind(Tornadoes_data1,Tornadoes_data2,Tornadoes_data3,Tornadoes_data4)

str(Tornadoes_data)
nrow(Tornadoes_data)

Tornadoes_data[sapply(Tornadoes_data, is.factor)] <- data.matrix(Tornadoes_data[sapply(Tornadoes_data, is.factor)])

###PCA 
Tornadoes_data.pca = Tornadoes_data[c("om","yr","mo","dy",
                                      "tz","st","stf","stn","mag","inj","fat",
                                      "loss","closs","slat","slon","elat","elon","len","wid","fc")]


pcamodel_Tornadoes_data1 = princomp(na.omit(Tornadoes_data.pca), cor = FALSE)


plot(pcamodel_Tornadoes_data1,main="Perceived Usefuleness Scree Plot")							#screeplot
biplot(pcamodel_Tornadoes_data1)

##Factor Analysis

Tornadoes_data.FA = factanal(~om+yr+mo+dy+tz+stf+st+
                               stn+mag+inj+fat+loss+closs+
                               slat+slon+elat+elon+len+wid+fc,
                             factors=2,
                             rotation="varimax",
                             scores="none",
                             data=Tornadoes_data)

Tornadoes_data.FA

##Kmeans

km = kmeans(data.frame(Tornadoes_data$om,Tornadoes_data$yr,Tornadoes_data$mo,Tornadoes_data$dy,Tornadoes_data$tz,Tornadoes_data$st,
                       Tornadoes_data$stf,Tornadoes_data$stn,Tornadoes_data$mag,Tornadoes_data$inj,Tornadoes_data$fat,
                       Tornadoes_data$loss,Tornadoes_data$closs,Tornadoes_data$slat,Tornadoes_data$slon,
                       Tornadoes_data$elat,Tornadoes_data$elon,Tornadoes_data$len,Tornadoes_data$wid,Tornadoes_data$fc), 6)

plot(Tornadoes_data$yr,Tornadoes_data$loss, col=km[[1]], main="6 KM Groups")

km2 = kmeans(data.frame(Tornadoes_data$om,Tornadoes_data$yr,Tornadoes_data$mo,Tornadoes_data$dy,Tornadoes_data$tz,Tornadoes_data$st,
                        Tornadoes_data$stf,Tornadoes_data$stn,Tornadoes_data$mag,Tornadoes_data$inj,Tornadoes_data$fat,
                        Tornadoes_data$loss,Tornadoes_data$closs,Tornadoes_data$slat,Tornadoes_data$slon,
                        Tornadoes_data$elat,Tornadoes_data$elon,Tornadoes_data$len,Tornadoes_data$wid,Tornadoes_data$fc), 4)

plot(Tornadoes_data$yr,Tornadoes_data$loss, col=km2[[1]], main="4 KM Groups")

par(mfrow=c(1,1))

table(km[[1]], Tornadoes_data$inj)

table(km[[1]], Tornadoes_data$st)

table(km2[[1]], Tornadoes_data$inj)

table(km2[[1]], Tornadoes_data$st)


##Multiple Regression

mreg = lm(Tornadoes_data$loss~Tornadoes_data$om+Tornadoes_data$yr+Tornadoes_data$mo+Tornadoes_data$dy+
            Tornadoes_data$tz+Tornadoes_data$stf+Tornadoes_data$stn+Tornadoes_data$mag+Tornadoes_data$inj+Tornadoes_data$fat
          +Tornadoes_data$closs+Tornadoes_data$slat+Tornadoes_data$slon+Tornadoes_data$elat+Tornadoes_data$elon+Tornadoes_data$len+Tornadoes_data$wid+Tornadoes_data$fc)
summary(mreg)

##Stepwise Regression 

sreg = step(lm(loss~yr+mo+dy+tz+stf+stn+mag+inj+fat+closs+slat+slon+elat+elon+len+wid+fc,data=Tornadoes_data),direction="both")

summary(sreg)

##Random Forest

Tornadoes_data1 = Tornadoes_data[c("om","yr","mo","dy",
                                    "tz","stf","stn","mag","inj","fat",
                                    "loss","closs","slat","slon","elat","elon","len","wid","fc")]

summary(Tornadoes_data1)


set.seed(123)
split = sample.split(Tornadoes_data1$loss, SplitRatio = 0.75)
training_set = subset(Tornadoes_data1, split == TRUE)
test_set = subset(Tornadoes_data1, split == FALSE)


summary(training_set)
summary(test_set)

training_set[-3] = scale(training_set[-3])
test_set[-3] = scale(test_set[-3])



classifier = randomForest(x = training_set[-3],
                          y = training_set$loss,
                          ntree = 500, random_state = 0)

plot(classifier)

y_pred = predict(classifier, newdata = test_set[-3])

cm = table(test_set[, 3], y_pred)
cm

mreg = lm(Tornadoes_data$slat~Tornadoes_data$mag+Tornadoes_data$len+Tornadoes_data$wid)
summary(mreg)

mreg = lm(Tornadoes_data$slon~Tornadoes_data$mag+Tornadoes_data$len+Tornadoes_data$wid)
summary(mreg)

mreg = lm(Tornadoes_data$fat~Tornadoes_data$yr+Tornadoes_data$mo+Tornadoes_data$dy+
            Tornadoes_data$tz+Tornadoes_data$stf+Tornadoes_data$stn+Tornadoes_data$mag+Tornadoes_data$inj
          +Tornadoes_data$closs+Tornadoes_data$slat+Tornadoes_data$slon+Tornadoes_data$elat+Tornadoes_data$elon+Tornadoes_data$len+Tornadoes_data$wid+Tornadoes_data$fc)
summary(mreg)


sreg = step(lm(Tornadoes_data$fat~Tornadoes_data$yr+Tornadoes_data$mo+Tornadoes_data$dy+
                 Tornadoes_data$tz+Tornadoes_data$stf+Tornadoes_data$stn+Tornadoes_data$mag+Tornadoes_data$inj
               +Tornadoes_data$closs+Tornadoes_data$slat+Tornadoes_data$slon+Tornadoes_data$elat+Tornadoes_data$elon+Tornadoes_data$len+Tornadoes_data$wid+Tornadoes_data$fat,data=Tornadoes_data),direction="both")

summary(sreg)

