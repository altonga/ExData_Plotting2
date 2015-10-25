# Code for plot3.png

# Point has seen an increase while the rest have seen a decrease from 1999-2008 in Baltimore City

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
library(dplyr)
library(ggplot2)
NEI_tbl_df <- tbl_df(NEI)
SCC_tbl_df <- tbl_df(SCC)
head(NEI_tbl_df)
NEI_tbl_df <- filter(NEI_tbl_df, fips == "24510")

NEI_by_type <- group_by(NEI_tbl_df, type, year)

NEI_by_type_emissions <- summarize(NEI_by_type, total = round(sum(Emissions, na.rm = TRUE), 3))
maxy <- ceiling(max(NEI_by_type_emissions$total))
NEI_by_type_emissions$type = factor(NEI_by_type_emissions$type)

png("plot3.png")

g <- ggplot(data=NEI_by_type_emissions, aes(year, total, color=type)) + 
     geom_point() + 
     geom_line(aes(group = type)) +
     labs(title = "Total Emissions by Type in Baltimore City", x ="Year", y = expression("Total Emissions, PM"[2.5]*"(Tons)")) 
print(g)
dev.off()