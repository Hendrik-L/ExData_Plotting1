# Course:     Exploratory Data Analysis (August 2015)
# Assignment: Course Project 1

# use the Cairo library for better anti-aliasing of png-graphics
library(Cairo)
# use the sqldf library in order to enable selective read-in
library(sqldf)

# read in only the required data rows and columns
energyUsageData <- read.csv.sql("household_power_consumption.txt", 
    sql = "select Date, Time, Global_active_power, Sub_metering_1, Sub_metering_2, 
    Sub_metering_3 from file where Date='1/2/2007' or Date='2/2/2007'", 
    header = TRUE, sep = ";")

# reformat date and time data according to Posix standard
tempDate <- energyUsageData$Date
tempTime <- energyUsageData$Time
tempDateTime <- paste(tempDate, tempTime)
energyUsageData$DateTime <- strptime(tempDateTime, "%d/%m/%Y %H:%M:%S")
energyUsageData <- cbind(energyUsageData$DateTime, energyUsageData[,3:6])
names(energyUsageData)[1] <- "Date_Time"

# prepare the png-plot number 1: a histogram with red bars
dataLabel <- "Global Active Power"
dataLabelExtended <- paste(dataLabel, "(kilowatts)")
plotData <- energyUsageData$Global_active_power

# this would use the base system, but produces an awful visual appearance with Windows anti-aliasing:
# png(filename = "plot1.png", width = 480, height = 480, bg = "transparent", type = "windows")

# this uses the Cairo system in order to gain visually appealing anti-aliasing also on Windows:
Cairo(file = "plot1.png", type = "png", width = 480, height = 480, bg = "white")

# plot and save the histogram
hist(plotData, col = "red", xlab = dataLabelExtended, main = dataLabel)

# finish and clean the environment
dev.off()
closeAllConnections()
remove(energyUsageData)