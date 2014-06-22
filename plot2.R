## Get Data 
require(data.table)
summarySCC <- readRDS("./exdata-data-NEI_data/summarySCC_PM25.rds")
summarySCC_dt <- data.table(summarySCC)
rm(summarySCC)

## Subset Data
sub <- subset(summarySCC_dt, fips == "24510") 
subSummary <- sub[,sum(Emissions), by = year]

## Create Plot
png(filename = "plot2.png", width = 480, height = 480)
plot(subSummary$year, subSummary$V1, type = "b", xlab = "Year", ylab = "Total Emmisions",
     main = "Trend of PM2.5 in Baltimore (fips-24510) from 1999 to 2008")
dev.off()