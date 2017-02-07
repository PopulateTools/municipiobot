library(gdata)
library(tidyr)

# Get the data
df_m <- read.xls("http://www.madrid.es/UnidadesDescentralizadas/UDCEstadistica/Nuevaweb/Demograf%C3%ADa%20y%20poblaci%C3%B3n/Esperanza/C6000116.xls", sheet = 2, fileEncoding="latin1", skip = 5, nrows = 22, colClasses=c(rep("NULL", 1), rep("character", 1), rep(NA, 21)), check.names=FALSE)
df_w <- read.xls("http://www.madrid.es/UnidadesDescentralizadas/UDCEstadistica/Nuevaweb/Demograf%C3%ADa%20y%20poblaci%C3%B3n/Esperanza/C6000116.xls", sheet = 3, fileEncoding="latin1", skip = 5, nrows = 22, colClasses=c(rep("NULL", 1), rep("character", 1), rep(NA, 21)), check.names=FALSE)

# Clean the dataframes
df_m <- df_m[-(1:1),]
colnames(df_m)[1] <- "district"
df_m$district <- substring(df_m$district, 6)

df_w <- df_w[-(1:1),]
colnames(df_w)[1] <- "district"
df_w$district <- substring(df_w$district, 6)

# Switch to long
df_m <- gather(df_m, age, life_exp, 2:22)
df_w <- gather(df_w, age, life_exp, 2:22)

df_m$gender <- "Hombre"
df_w$gender <- "Mujer"

# Concatenate the dataframes
data <- rbind(df_m, df_w)

data$municipality_id <- "28079"

write.csv(data, "output/data.csv", row.names = FALSE)
