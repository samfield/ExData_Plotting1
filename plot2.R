#The following script implements submission 1/part 2 of Exploratory Data Analysis course in Coursera
#This script depends on:
##A working outside connection to the web: for downloading the data
##Access to data.table and ggplot2 libraries for easier plotting and data handling

##LOAD PACKAGES
require(data.table)
require(ggplot2)
library(scales)

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

#PLOT 2
plot2 <- ggplot() + geom_line(data=dt, aes(x=datetime,y=global_active_power)) + 
  scale_x_datetime(labels=date_format("%a"), breaks=date_breaks("1 days")) + 
  ylab("Global Active Power (kilowats)") +
  xlab("") +
  theme_classic()

#save plot
ggsave(filename = paste(getwd(),"plot2.png",sep = "/"), plot = plot2, width =6.4,height = 6.4, units = "in", dpi = 75)
