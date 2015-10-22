
#NEI <- readRDS("summarySCC_PM25.rds")
#SCC <- readRDS("Source_Classification_Code.rds")
library(dplyr)
library(ggplot2)
NEI_tbl_df <- tbl_df(NEI)
NEI_tbl_df <- filter(NEI_tbl_df, fips == "24510" | fips == "06037")
SCC_tbl_df <- tbl_df(SCC)
head(SCC_tbl_df)
SCC_Motor <- grep("motor", SCC_tbl_df$Short.Name, ignore.case = TRUE )
SCC_Motor_Entries <- SCC_tbl_df[SCC_Motor, ]
MotorSCC <- SCC_Motor_Entries$SCC
UniqueMotorSCC <- unique(MotorSCC)

NEI_Motor <- NEI_tbl_df[NEI_tbl_df$SCC %in% UniqueMotorSCC,  ]

NEI_Motor_by_year <- group_by(NEI_Motor, fips, year)
NEI_Motor_by_year_emissions <- summarize(NEI_Motor_by_year, total = round(sum(Emissions, na.rm = TRUE), 3))
maxy <- ceiling(max(NEI_Motor_by_year_emissions$total))

png("plot6.png")



g <- ggplot(data=NEI_Motor_by_year_emissions, aes(year, total, color=fips)) + 
    geom_point() + 
    geom_line(aes(group = fips)) +
    labs(title = "Total Emissions per Year", x ="Year", y = expression("Total Emissions, PM"[2.5]*"(Tons)")) 
print(g)

dev.off()