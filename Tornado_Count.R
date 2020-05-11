library(ggplot2)
library(dplyr)

setwd("C:\\Users\\nishi\\source\\repos\\Project_MSIS5223")
getwd()

Tornadoes_data_count = read.table("tornadoes_data_yr_count.csv", sep=",",header=TRUE)
str(Tornadoes_data_count)
Tornadoes_data_count

#Tornado Count
ggplot(data=Tornadoes_data_count) +
  geom_line(mapping = aes(x = yr, y = COUNTTORNADOES), color="red") +
  ggtitle("Number of Tornadoes (1950-2018)") +
scale_x_discrete(name="Year", limits=c(1950,1960,1970,1980,1990,2000,2010,2018)) +
  scale_y_continuous(name="Tornadoes", limits=c(0, 2000))

#Tornado Count: Smooth Graph
ggplot(data=Tornadoes_data_count) +
  geom_smooth(mapping = aes(x = yr, y = COUNTTORNADOES)) +
  ggtitle("Number of Tornadoes (1950-2018)") +
  theme_light()+
  scale_x_discrete(name="Year", limits=c(1950,1960,1970,1980,1990,2000,2010,2018)) +
  scale_y_continuous(name="Tornadoes", limits=c(0, 2000)) 



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

# Plot between Average Longitude and Year

yearly <- Tornadoes_data %>% group_by(yr) %>% summarize(avglat = mean(slat), avglong = mean(slon))
ggplot(data=yearly) +
  geom_point(mapping = aes(x = yr, y = avglong), color="blue") + 
  ggtitle("Average longitude (1950-2018)") + theme_classic()+
  xlab("Year") + ylab("Average Starting Longitude") + 
  theme(legend.position="none")

tornadoLong <- ggplot(data=yearly) +
  geom_smooth(mapping = aes(x = yr, y = avglong)) +
  ggtitle("Average longitude (1950-2018)") + theme_classic()+
  scale_x_discrete(name="Year", limits=c(1950,1960,1970,1980,1990,2000,2010,2018)) +
  scale_y_continuous(name="Average Starting Longitude") + 
  theme(legend.position="none")

# Plot between Average Latitude and Year
ggplot(data=yearly) +
  geom_point(mapping = aes(x = yr, y = avglat), color="blue") + 
  ggtitle("Average latitude (1950-2018)") + theme_classic()+
  xlab("Year") + ylab("Average Starting Latitude") + 
  theme(legend.position="none")

tornadoLat <- ggplot(data=yearly) +
  geom_smooth(mapping = aes(x = yr, y = avglat)) +
  ggtitle("Average latitude (1950-2018)") + theme_classic()+
  scale_x_discrete(name="Year", limits=c(1950,1960,1970,1980,1990,2000,2010,2018)) +
  scale_y_continuous(name="Average Starting Latitude") + 
  theme(legend.position="none")

#Tornado Lat and Long
grid.arrange(tornadoLong, tornadoLat, ncol=2)




       