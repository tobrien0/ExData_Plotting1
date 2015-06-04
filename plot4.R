### plot4.R - generate plot4.png ##################################################################

### set project environment: libraries #########################################
library(downloader)
library(sqldf)

### set project variables  #####################################################
dirData <- "./data"
sqlStmt <- "select * from file where Date = '1/2/2007' or Date = '2/2/2007'"
srcFile <- paste(dirData, "household_power_consumption.txt", sep = "/")
srcZip <- paste(dirData, "dataset.zip", sep = "/")
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

### get the source data ########################################################
### create a directory for the source data
if(!file.exists(dirData)){dir.create(dirData)}

### download the src data
download(url, dest=srcZip, mode="wb")

### "record" date downloaded - best practice
dateDownloaded <- date()
dateDownloaded

### unzip the srcZip to srcFile
unzip(srcZip, exdir = dirData)

### Load the raw data using the sqlStmt which minimizes the size of df #########
df <- read.csv.sql(
        srcFile,
        sep = ";",
        header=TRUE,
        stringsAsFactors=FALSE,
        colClasses=c("character", "character", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric"),
        sql = sqlStmt
)
closeAllConnections()

### Exploration
names(df)
summary(df)

### Convert date and time strings to date and time objects######################
#df$Date <- as.Date(df$Date, format="%d/%m/%y")
#df$Time <- strptime(df$Time, format="%H:%M:%S")
df$DateTime <- as.POSIXct(paste(df$Date, df$Time, sep=" "), format="%d/%m/%Y %H:%M:%S")

### Create plot4.png ###########################################################
### create the plot file in the working directory
png(filename="plot4.png", width=480, height=480)
par(mfcol=c(2,2))

### upper left chart
plot(
        df$DateTime,
        df$Global_active_power,
        col="black",
        main="",
        xlab="",
        ylab="Global Active Power (kilowatts)",
        type="l"
)

### lower left chart
plot(
        df$DateTime,
        df$Sub_metering_1,
        col="black",
        main="",
        xlab="",
        ylab="Energy Sub Metering",
        type="l"
)
lines(df$DateTime, df$Sub_metering_2, col="red")
lines(df$DateTime, df$Sub_metering_3, col="blue")
legend(
        "topright",
        col = c("black", "red", "blue"),
        legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
        lty=1,
        lwd=1
)

### upper right chart
plot(
        df$DateTime,
        df$Voltage,
        col="black",
        main="",
        xlab="datetime",
        ylab="Voltage",
        type="l"
)

### lower right chart
plot(
        df$DateTime,
        df$Global_reactive_power,
        col="black",
        main="",
        xlab="datetime",
        ylab="Global_reactive_power",
        type="l"
)

dev.off()

### Cleanup ####################################################################
rm(dateDownloaded)
rm(df)
rm(dirData)
rm(sqlStmt)
rm(srcFile)
rm(srcZip)
rm(url)
#rm(xlimit)
#rm(ylimit)
