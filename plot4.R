# Course:     Exploratory Data Analysis (August 2015)
# Assignment: Course Project 1

# use the Cairo library for better anti-aliasing of png-graphics
library(Cairo)
# use the sqldf library in order to enable selective read-in
library(sqldf)

# read in only the required data rows and columns
energyUsageData <- read.csv.sql("household_power_consumption.txt", 
    sql = "select Date, Time, Global_active_power, Sub_metering_1, Sub_metering_2, 
    Sub_metering_3, Voltage, Global_reactive_power from file where Date='1/2/2007' or Date='2/2/2007'", 
    header = TRUE, sep = ";")

# reformat date and time data according to Posix standard
tempDate <- energyUsageData$Date
tempTime <- energyUsageData$Time
tempDateTime <- paste(tempDate, tempTime)
energyUsageData$DateTime <- strptime(tempDateTime, "%d/%m/%Y %H:%M:%S")
energyUsageData <- cbind(energyUsageData$DateTime, energyUsageData[,3:8])
names(energyUsageData)[1] <- "Date_Time"

# prepare the 2 by 2 matrix
Cairo(file = "plot4.png", type = "png", width = 480, height = 480, bg = "white")
par(mfrow = c(2, 2))

# prepare the upper left chart
xData <- energyUsageData$Date_Time
yData <- energyUsageData$Global_active_power
yDataLabel <- "Global Active Power"
plot(xData, yData, type = "l", xlab = "", ylab = yDataLabel)

# prepare the upper right chart
yData <- energyUsageData$Voltage
xDataLabel <- "datetime"
yDataLabel <- "Voltage"
plot(xData, yData, type = "l", xlab = xDataLabel, ylab = yDataLabel)

# prepare the lower left chart
xData <- energyUsageData$Date_Time
yData1 <- energyUsageData$Sub_metering_1
yData2 <- energyUsageData$Sub_metering_2
yData3 <- energyUsageData$Sub_metering_3
yDataLabel <- "Energy sub metering"
plot(xData, yData1, type = "n", xlab = "", ylab = yDataLabel)
lines(xData, yData1, col = "black")
lines(xData, yData2, col = "red")
lines(xData, yData3, col = "blue")
legend("topright", legend = names(energyUsageData[,3:5]), col = c("black", "red", "blue"), lwd = 1, bty = "n")

# prepare the lower right chart
yData <- energyUsageData$Global_reactive_power
xDataLabel <- "datetime"
yDataLabel <- names(energyUsageData[ncol(energyUsageData)])
plot(xData, yData, type = "l", xlab = xDataLabel, ylab = yDataLabel)

# finish and clean the environment
dev.off()
closeAllConnections()
remove(energyUsageData)