#The following script implements submission 1/part 4 of Exploratory Data Analysis course in Coursera
#This script depends on:
##A working outside connection to the web: for downloading the data
##Access to data.table and ggplot2 libraries for easier plotting and data handling

##LOAD PACKAGES
require(data.table)
require(ggplot2)
library(scales)
library(gridExtra)

#set locale for english abbreviations on time
Sys.setenv(LANGUAGE="en")
Sys.setlocale("LC_TIME", "English")

##LOAD DATA & MANGLE

#directories;
#define the where the zip file is downloaded
temp <- paste(getwd(), "data.zip", sep = "/")
#define the url of the file
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

#download:
#download the file as binary
download.file(url = url,temp, mode = "wb")
#unzip the loaded file to the working directory then load a data.table with fread function
dt <- fread(unzip(temp), verbose = TRUE, colClasses = "character" )
#remove the downloaded file, unzipped file will remain in the working directory
unlink(temp)

#mangle:
#setkey for faster index
setkey(dt, Date)
#only observations from 2007-02-01 and 2007-02-02 are needed. Subset the data,
dt <- dt[Date %in% "1/2/2007" | Date %in% "2/2/2007",]
#set variable names to lowercase
setnames(dt, names(dt), tolower(names(dt)))
#set classes to date and time
dt[,datetime:=paste(date,time,sep = " ")]
dt[,datetime:=as.POSIXct(strptime(dt$datetime, format = "%d/%m/%Y %H:%M:%S"))]
#set numeric
dt[,global_active_power:=as.numeric(global_active_power)]
dt[,global_reactive_power :=as.numeric(global_reactive_power)]
dt[,global_intensity :=as.numeric(global_intensity)]
dt[,sub_metering_1 :=as.numeric(sub_metering_1)]
dt[,sub_metering_2 :=as.numeric(sub_metering_2)]
dt[,sub_metering_3 :=as.numeric(sub_metering_3)]
dt[,voltage :=as.numeric(voltage)]
dt[,date:=as.Date(date, format= "%d/%m/%Y")]


#PLOT Left_top
plot2 <- ggplot() + geom_line(data=dt, aes(x=datetime,y=global_active_power)) + 
  scale_x_datetime(labels=date_format("%a"), breaks=date_breaks("1 days")) + 
  ylab("Global Active Power") +
  xlab("") +
  theme_classic()

#PLOT Left_bottom
plot3 <- ggplot(data=dt, aes(x=datetime)) + 
  geom_line(aes(y=sub_metering_1,color="sub_metering_1")) + 
  geom_line(aes(y=sub_metering_2,colour="sub_metering_2")) +
  geom_line(aes(y=sub_metering_3,colour="sub_metering_3")) +
  scale_colour_manual("", 
                      breaks = c("sub_metering_1", "sub_metering_2", "sub_metering_3"),
                      values = c("black", "red", "blue")) +
  scale_x_datetime(labels=date_format("%a"), breaks=date_breaks("1 days")) + 
  ylab("Energy sub metering") +
  xlab("") + theme_classic() + 
  theme(legend.justification=c(1,1), legend.position=c(1,1), legend.key = element_rect(colour = "black"))

#PLOT right_top
plot4 <- ggplot() + geom_line(data=dt, aes(x=datetime,y=voltage)) + 
  scale_x_datetime(labels=date_format("%a"), breaks=date_breaks("1 days")) + 
  ylab("Voltage") +
  xlab("datetime") +
  theme_classic()
#PLOT right_bottom
plot5 <- ggplot() + geom_line(data=dt, aes(x=datetime,y=global_reactive_power)) + 
  scale_x_datetime(labels=date_format("%a"), breaks=date_breaks("1 days")) + 
  xlab("datetime") +
  theme_classic()

png("Plot4.png")
grid.arrange(plot2,plot4,plot3,plot5)
dev.off()
