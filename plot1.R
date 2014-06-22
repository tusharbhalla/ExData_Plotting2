## Get Data 
require(data.table)
summarySCC <- readRDS("./exdata-data-NEI_data/summarySCC_PM25.rds")
summarySCC_dt <- data.table(summarySCC)
rm(summarySCC)

## Subset Data
summary <- summarySCC_dt[,sum(Emissions), by = year]

## Create Plot 1
png(filename = "plot1.png", width = 480, height = 480)
plot(summary$year, summary$V1, type = "b", xlab = "Year", ylab = "Total Emmisions",
     main = "Trend of PM2.5 from 1999 to 2008")
dev.off()