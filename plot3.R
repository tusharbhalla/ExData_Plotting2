## Get Data 
require(data.table)
require(ggplot2)
summarySCC <- readRDS("./exdata-data-NEI_data/summarySCC_PM25.rds")
summarySCC_dt <- data.table(summarySCC)
rm(summarySCC)

## Subset Data
sub <- subset(summarySCC_dt, fips == "24510") 
plot3Summary <- sub[,sum(Emissions), by = list(year,type)]

## Create Plot
png(filename = "plot3.png", width = 480, height = 480)
ggplot(plot3Summary, aes(x=year, y=V1, color = type)) +
        geom_line() +
        geom_point() +
        labs(x = "Year", y = "Total Emissions") +
        labs(title = "PM2.5 Emissions in Baltimore by Source Type")
dev.off()