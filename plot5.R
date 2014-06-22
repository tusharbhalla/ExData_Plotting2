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
summarySCC_sub <- subset(summarySCC_dt, fips == "24510")
summary <- summarySCC_sub[,sum(Emissions), by = list(year,type,SCC)]
summary <- summary[,EI.Sector:=SCC]
summary$EI.Sector <- sourceClass[summary$EI.Sector,]$EI.Sector
rm(summarySCC_dt)
rm(sourceClass)
rm(summarySCC_sub)

## Subset data for Coal Only
subset <- summary[which(grepl("Mobile", EI.Sector)), ]
rm(summary)

## Subset Data
plot5Summary <- subset[,sum(V1), by = year]
rm(subset)
setkey(plot5Summary, year)


## Create Plot
png(filename = "plot5.png", width = 480, height = 480)
plot(plot5Summary$year, plot5Summary$V1, type = "b", xlab = "Year", ylab = "Total Emmisions",
     main = "Trend of PM2.5 in Baltimore from 1999 to 2008 by Motor Vehicles")
dev.off()