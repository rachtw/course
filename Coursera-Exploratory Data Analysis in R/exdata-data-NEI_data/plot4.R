NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Find out the index of SCC where any of the four columns contains "Coal"
SCCindexCoal <- sort(union(union(union(grep("Coal",SCC$Short.Name),grep("Coal",SCC$EI.Sector)),grep("Coal", SCC$SCC.Level.Three)),grep("Coal", SCC$SCC.Level.Four)))
## Find out the index of SCC where any of the six columns contains "Combustion"
SCCindexCombustion <- sort(union(union(union(union(union(grep("Combustion",SCC$Short.Name),grep("Combustion",SCC$EI.Sector)),grep("Combustion", SCC$SCC.Level.Three)),grep("Combustion", SCC$SCC.Level.Four)),grep("Combustion", SCC$SCC.Level.Two)),grep("Combustion", SCC$SCC.Level.One)))
## Find out the index of SCC where at least one column contains "Coal" and at least one column contains "Combustion"
SCCindex <- intersect(SCCindexCoal,SCCindexCombustion)

## Get the SCC associated with "coal combustion"
CoalSCC <- SCC$SCC[SCCindex]

## Get the data of source "coal combustion"
NEICoal <- NEI[which(NEI$SCC %in% CoalSCC),]

## Calculate log(Emission) and remove inf values
logEmissions = log(NEICoal$Emissions)
logEmissions2 = replace(logEmissions, is.infinite(logEmissions),NA)
NEICoal$logEmissions = logEmissions2

## Create point plots of log(Emission) vs year and a line of linear regressions
png(filename = "plot4.png")
q <- qplot(year, logEmissions, data = NEICoal, geom = c("point", "smooth"), method = "lm", main = "Emissions of Coal Combustion Sources")
q + theme(axis.text.x = element_text(angle = 90, hjust = 1)) +  labs(y = "log(Emissions)")
dev.off()

## Sum up the total emission by year
totalCoal <- with(NEICoal, tapply(Emissions, year, sum, na.rm = T))

## Generate the bar plot
barplot(totalCoal, main="Total Emission", xlab="Year")
