NEI <- readRDS("summarySCC_PM25.rds")

## Sum up the total emission by year
total <- with(NEI, tapply(Emissions, year, sum, na.rm = T))

## Generate the bar plot
png(filename = "plot1.png")
barplot(total, main="Total Emission", xlab="Year")
dev.off()
