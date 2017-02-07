library(httr)
library(jsonlite)
library(dplyr)

# Get data and budget categories from the TBI API
url_data <- "https://tbi.populate.tools/gobierto/datasets/ds-presupuestos-municipales-partida.json?sort_desc_by=date&with_metadata=true&filter_by_municipality_id=08019&filter_by_year=2016"
get_data <- GET(url=url_data, add_headers(Authorization=paste("Bearer", Sys.getenv("POPULATE_DATA_TOKEN"), sep=" "), Origin="http://madrid.gobierto.dev"))
data <- fromJSON(content(get_data, type="text"))

url_cat <- "https://tbi.populate.tools/gobierto/collections/c-categorias-presupuestos-municipales/items.json"
get_cat <- GET(url=url_cat, add_headers(Authorization=paste("Bearer", Sys.getenv("POPULATE_DATA_TOKEN"), sep=" "), Origin="http://madrid.gobierto.dev"))
cat <- fromJSON(content(get_cat, type="text"))

# Join
df <- data$data
df <- filter(df, is.na(functional_code))

merged <- merge(df, cat, by=c("area","kind", "code"))
merged <- filter(merged, area == 'functional')

# Write the CSV
#write.csv(merged, file = "output/data.csv")
