NEI <- readRDS("summarySCC_PM25.rds")

## Get the data of Baltimore
xBaltimore <- subset(NEI,fips=="24510" | fips==24510)

## Sum up the total emission by year
total <- with(xBaltimore, tapply(Emissions, year, sum, na.rm = T))

## Generate the bar plot
png(filename = "plot2.png")
barplot(total, main="Total Emission of Baltimore City", xlab="Year")
dev.off()
