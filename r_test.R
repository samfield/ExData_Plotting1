#The following script implements submission 1/part 1 of Exploratory Data Analysis course in Coursera
#This script depends on:
##A working outside connection to the web: for downloading the data
##Access to data.table and ggplot2 libraries for easier plotting and data handling


require(data.table)
require(ggplot2)

temp <- getwd()
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(url = url,temp)
data <- fread(unzip(temp, "a1.dat"))
unlink(temp)



test <- fread("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", verbose = TRUE) 
