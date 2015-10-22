
#NEI <- readRDS("summarySCC_PM25.rds")
#SCC <- readRDS("Source_Classification_Code.rds")
library(dplyr)
library(ggplot2)
NEI_tbl_df <- tbl_df(NEI)
NEI_tbl_df <- filter(NEI_tbl_df, fips == "24510")
SCC_tbl_df <- tbl_df(SCC)
head(SCC_tbl_df)
SCC_Motor <- grep("motor", SCC_tbl_df$Short.Name, ignore.case = TRUE )
SCC_Motor_Entries <- SCC_tbl_df[SCC_Motor, ]
MotorSCC <- SCC_Motor_Entries$SCC
UniqueMotorSCC <- unique(MotorSCC)

NEI_Motor <- NEI_tbl_df[NEI_tbl_df$SCC %in% UniqueMotorSCC,  ]

NEI_Motor_by_year <- group_by(NEI_Motor, year)
NEI_Motor_by_year_emissions <- summarize(NEI_Motor_by_year, total = round(sum(Emissions, na.rm = TRUE), 3))
maxy <- ceiling(max(NEI_Motor_by_year_emissions$total))

png("plot5.png")

plot(NEI_Motor_by_year_emissions$year, NEI_Motor_by_year_emissions$total)  



plot(NEI_Motor_by_year_emissions$year, NEI_Motor_by_year_emissions$total, type="l", 
     xlab="Year", ylab=expression("Total Emissions, PM"[2.5]*"(Tons)"), xaxt="n",  
     col="blue", 
     xlim=c(1998, 2014), ylim =c(0, maxy), main="Total Emissions Every Year for Motor Vehicles in Baltimore City")
axis(1, at = seq(1999, 2011, by = 3), las = 2)
points(NEI_Motor_by_year_emissions$year, NEI_Motor_by_year_emissions$total, pch = 4, col="green")
text(NEI_Motor_by_year_emissions$year, NEI_Motor_by_year_emissions$total, NEI_Motor_by_year_emissions$total, cex=0.6, pos=4, col="red")




#     geom_point() + 
#     geom_line(aes(group = type)) +
#     labs(title = "Total Emissions per Year by Type", x ="Year", y = expression("Total Emissions, PM"[2.5]*"(Tons)")) 
#print(g)
dev.off()