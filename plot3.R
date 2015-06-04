### plot3.R - generate plot3.png ##################################################################

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

### Create plot3.png ###########################################################
### create the plot file in the working directory
png(filename="plot3.png", width=480, height=480)

plot(df$DateTime,
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
        lwd=1,
        lty=1,
        col = c("black", "red", "blue"),
        legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3")
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
