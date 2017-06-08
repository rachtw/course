power <- read.table("household_power_consumption.txt",header=TRUE,sep=";",na.strings=c("?"))
power2 <- subset(power,power$Date=="1/2/2007" |  power$Date=="2/2/2007")
power2$Time2 <- strptime(paste(power2$Date,power2$Time),format="%d/%m/%Y %H:%M:%S")
power2$Date <- as.Date(strptime(power2$Date,format="%d/%m/%Y"))

png(filename = "plot4.png")

par(mar=c(3,4,1,1))
par(mfrow = c(2,2))

plot(power2$Time2,power2$Global_active_power,type="l",xlab="",ylab="Global Active Power",cex.lab=0.5,cex.axis=0.7)

plot(power2$Time2,power2$Voltage,type="l",xlab="",ylab="Voltage",cex.lab=0.5,cex.axis=0.7)

plot(power2$Time2,power2$Sub_metering_1,type="l",xlab="",ylab="Energy sub metering",cex.lab=0.5,cex.axis=0.7)
lines(power2$Time2,power2$Sub_metering_2,col="red")
lines(power2$Time2,power2$Sub_metering_3,col="blue")
legend("topright",c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),col=c("black","red","blue"),lty=c(1,1,1),cex=0.7)

plot(power2$Time2,power2$Global_reactive_power,type="l",xlab="",ylab="Global Reactive Power",cex.lab=0.5,cex.axis=0.7)

dev.off()
