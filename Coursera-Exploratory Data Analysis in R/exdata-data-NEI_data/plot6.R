NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Find out the index of SCC where any of the four columns contains "Motor"
SCCindex <- sort(union(union(union(grep("Motor",SCC$Short.Name),grep("Motor",SCC$EI.Sector)),grep("Motor", SCC$SCC.Level.Three)),grep("Motor", SCC$SCC.Level.Four)))

## Get the SCC associated with "Motor"
MotorSCC <- SCC$SCC[SCCindex]

## Get the data associated with motor vehicles
NEIMotor <- NEI[which(NEI$SCC %in% MotorSCC),]

## Get the data associated with motor vehicles in Baltimore City or Los Angeles County
NEIMotorBaltimoreLA <- subset(NEIMotor,fips=="24510" | fips=="06037")

## Replace numeric fips with region names
NEIMotorBaltimoreLA$fips = as.factor(NEIMotorBaltimoreLA$fips)
levels(NEIMotorBaltimoreLA$fips) = c("Los Angeles County", "Baltimore City")

## Create point plots of Emission vs year and lines of linear regressions
png(filename = "plot6.png")
q <- qplot(year, Emissions, data = NEIMotorBaltimoreLA, facets = . ~ fips, geom = c("point", "smooth"), method = "lm", main = "Emissions of Motor Vehicles")
q + theme(axis.text.x = element_text(angle = 90, hjust = 1)) +  labs(y = "emissions")
dev.off()
