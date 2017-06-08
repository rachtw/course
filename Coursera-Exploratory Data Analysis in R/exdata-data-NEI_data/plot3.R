NEI <- readRDS("summarySCC_PM25.rds")

## Get the data of Baltimore
xBaltimore <- subset(NEI,fips=="24510")

## Calculate log(Emission) and remove inf values
logEmissions = log(xBaltimore$Emissions)
logEmissions2 = replace(logEmissions, is.infinite(logEmissions),NA)
xBaltimore$logEmissions = logEmissions2

## Create point plots of log(Emission) vs year by type and lines of linear regressions
png(filename = "plot3.png")
q <- qplot(year, logEmissions, data = xBaltimore, facets = . ~ type, geom = c("point", "smooth"), method = "lm", main = "Emissions of Baltimore City")
q + theme(axis.text.x = element_text(angle = 90, hjust = 1)) +  labs(y = "log(Emissions)")
dev.off()
