
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
library(dplyr)
library(ggplot2)
NEI_tbl_df <- tbl_df(NEI)
SCC_tbl_df <- tbl_df(SCC)
head(SCC_tbl_df)
SCC_Comb <- grep("Comb", SCC_tbl_df$Short.Name, ignore.case = TRUE )
SCC_Comb_Entries <- SCC_tbl_df[SCC_Comb, ]
SCC_Comb_Coal <- grep("Coal", SCC_Comb_Entries$Short.Name, ignore.case = TRUE)
SCC_Comb_Coal_Entries <- SCC_Comb_Entries[SCC_Comb_Coal, ]
CombCoalSCC <- SCC_Comb_Coal_Entries$SCC
UniqueCombCoalSCC <- unique(CombCoalSCC)

NEI_Comb_Coal <- NEI_tbl_df[NEI_tbl_df$SCC %in% UniqueCombCoalSCC,  ]

NEI_Comb_Coal_by_year <- group_by(NEI_Comb_Coal, year)
NEI_Comb_Coal_by_year_emissions <- summarize(NEI_Comb_Coal_by_year, total = round(sum(Emissions, na.rm = TRUE), 3))
maxy <- ceiling(max(NEI_Comb_Coal_by_year_emissions$total))

png("plot4.png")

plot(NEI_Comb_Coal_by_year_emissions$year, NEI_Comb_Coal_by_year_emissions$total)  



plot(NEI_Comb_Coal_by_year_emissions$year, NEI_Comb_Coal_by_year_emissions$total, type="l", 
     xlab="Year", ylab=expression("Total Emissions, PM"[2.5]*"(Tons)"), xaxt="n",  
     col="blue", 
     xlim=c(1998, 2014), ylim =c(0, maxy), main="Total Emissions Every Year for Coal Combustion Sources")
axis(1, at = seq(1999, 2011, by = 3), las = 2)
points(NEI_Comb_Coal_by_year_emissions$year, NEI_Comb_Coal_by_year_emissions$total, pch = 4, col="green")
text(NEI_Comb_Coal_by_year_emissions$year, NEI_Comb_Coal_by_year_emissions$total, NEI_Comb_Coal_by_year_emissions$total, cex=0.6, pos=4, col="red")




#     geom_point() + 
#     geom_line(aes(group = type)) +
#     labs(title = "Total Emissions per Year by Type", x ="Year", y = expression("Total Emissions, PM"[2.5]*"(Tons)")) 
#print(g)
dev.off()