## Get Data 
require(data.table)
require(ggplot2)
summarySCC <- readRDS("./exdata-data-NEI_data/summarySCC_PM25.rds")
summarySCC_dt <- data.table(summarySCC)
rm(summarySCC)
setkey(summarySCC_dt, SCC)

sourceClassification <- readRDS("./exdata-data-NEI_data/Source_Classification_Code.rds")
sourceClass <- data.table(sourceClassification)
rm(sourceClassification)
setkey(sourceClass, SCC)

## Group by and then merge the dataset
summary <- summarySCC_dt[,sum(Emissions), by = list(year,type,SCC)]
summary <- summary[,EI.Sector:=SCC]
summary$EI.Sector <- sourceClass[summary$EI.Sector,]$EI.Sector
rm(summarySCC_dt)
rm(sourceClass)

## Subset data for Coal Only
subset <- summary[which(grepl("Coal", EI.Sector)), ]
rm(summary)

## Subset Data
plot4Summary <- subset[,sum(V1), by = year]
rm(subset)

## Create Plot
png(filename = "plot4.png", width = 480, height = 480)
plot(plot4Summary$year, plot4Summary$V1, type = "b", xlab = "Year", ylab = "Total Emmisions",
     main = "Trend of PM2.5 from 1999 to 2008 by Coal Sources")
dev.off()