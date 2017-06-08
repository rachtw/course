power <- read.table("household_power_consumption.txt",header=TRUE,sep=";",na.strings=c("?"))
power2 <- subset(power,power$Date=="1/2/2007" |  power$Date=="2/2/2007")
power2$Date <- as.Date(strptime(power2$Date,format="%d/%m/%Y"))

png(filename = "plot1.png")
par(mar=c(3,4,1,1))
hist(power2$Global_active_power,main="Global Active Power",xlab="Global Active Power (killowatts)",col="red",xlim=c(0,6),ylim=c(0,1300))
dev.off()
