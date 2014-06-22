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
summarySCC_balti <- subset(summarySCC_dt, fips == "24510")
summarySCC_balti[,City:="Baltimore"]
summarySCC_LA <- subset(summarySCC_dt, fips == "06037")
summarySCC_LA[,City:="Los Angeles"]
summarySCC_sub <- rbind(summarySCC_balti,summarySCC_LA)
summary <- summarySCC_sub[,sum(Emissions), by = list(year,City,SCC)]
summary <- summary[,EI.Sector:=SCC]
summary$EI.Sector <- sourceClass[summary$EI.Sector,]$EI.Sector
rm(summarySCC_dt)
rm(sourceClass)
rm(summarySCC_sub)
rm(summarySCC_balti)
rm(summarySCC_LA)

## Subset data for Motor Vehicles Only
subset <- summary[which(grepl("Mobile", EI.Sector)), ]
rm(summary)

## Subset Data
plot6Summary <- subset[,sum(V1), by = list(year,City)]
rm(subset)
setkey(plot5Summary, year)


## Create Plot
png(filename = "plot6.png", width = 480, height = 480)
ggplot(plot6Summary, aes(x=year, y=V1, color = City)) +
        geom_line() +
        geom_point() +
        labs(x = "Year", y = "Total Emissions") +
        labs(title = "PM2.5 Emissions in Baltimore & Los Angeles from Motor Vehicles")

dev.off()