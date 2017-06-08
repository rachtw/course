NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Find out the index of SCC where any of the four columns contains "Motor"
SCCindex <- sort(union(union(union(grep("Motor",SCC$Short.Name),grep("Motor",SCC$EI.Sector)),grep("Motor", SCC$SCC.Level.Three)),grep("Motor", SCC$SCC.Level.Four)))

## Get the SCC associated with "Motor"
MotorSCC <- SCC$SCC[SCCindex]

## Get the data associated with motor vehicles
NEIMotor <- NEI[which(NEI$SCC %in% MotorSCC),]

## Get the data associated with motor vehicles in Baltimore City
NEIMotorBaltimore <- subset(NEIMotor,fips=="24510")

## Calculate log(Emission) and remove inf values
logEmissions = log(NEIMotorBaltimore$Emissions)
logEmissions2 = replace(logEmissions, is.infinite(logEmissions),NA)
NEIMotorBaltimore$logEmissions = logEmissions2

## Create point plots of log(Emission) vs year and a line of linear regression
png(filename = "plot5.png")
q <- qplot(year, logEmissions, data = NEIMotorBaltimore, geom = c("point", "smooth"), method = "lm", main = "Emissions of Motor Vehicles in Baltimore City")
q + theme(axis.text.x = element_text(angle = 90, hjust = 1)) +  labs(y = "log(Emissions)")
dev.off()
