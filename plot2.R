# Code for plot2.png

# Total emissions in Baltimore has decresed from 1999 to 2008 but had an increase between 2002 and 2005.


NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
library(dplyr)
NEI_tbl_df <- tbl_df(NEI)
SCC_tbl_df <- tbl_df(SCC)
head(NEI_tbl_df)
NEI_tbl_df <- filter(NEI_tbl_df, fips == "24510")
NEI_by_year <- group_by(NEI_tbl_df, year)
NEI_by_year_emissions <- summarize(NEI_by_year, total = round(sum(Emissions, na.rm = TRUE), 3))
maxy <- ceiling(max(NEI_by_year_emissions$total))
png("plot2.png")
plot(NEI_by_year_emissions$year, NEI_by_year_emissions$total, type="l", 
     xlab="Year", ylab=expression("Total Emissions, PM"[2.5]*"(Tons)"), xaxt="n", 
     col="blue", 
     xlim=c(1998, 2014), ylim =c(0, maxy), main="Total Emissions in Baltimore City")
axis(1, at = seq(1999, 2011, by = 3), las = 2)
points(NEI_by_year_emissions$year, NEI_by_year_emissions$total, pch = 4, col="green")
text(NEI_by_year_emissions$year, NEI_by_year_emissions$total, NEI_by_year_emissions$total, cex=0.6, pos=4, col="red")

dev.off()