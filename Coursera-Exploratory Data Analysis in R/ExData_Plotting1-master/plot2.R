power <- read.table("household_power_consumption.txt",header=TRUE,sep=";",na.strings=c("?"))
power2 <- subset(power,power$Date=="1/2/2007" |  power$Date=="2/2/2007")
power2$Time2 <- strptime(paste(power2$Date,power2$Time),format="%d/%m/%Y %H:%M:%S")
power2$Date <- as.Date(strptime(power2$Date,format="%d/%m/%Y"))

png(filename = "plot2.png")
par(mar=c(3,4,1,1))
plot(power2$Time2,power2$Global_active_power,type="l",xlab="",ylab="Global Active Power (killowatts)")
dev.off()
