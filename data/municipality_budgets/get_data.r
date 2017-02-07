library(httr)
library(jsonlite)

# Get data from the TBI API
url <- "https://tbi.populate.tools/gobierto/datasets/ds-presupuestos-municipales-partida.json?sort_desc_by=date&with_metadata=true&filter_by_municipality_id=39075"
get_data <- GET(url=url, add_headers(Authorization=paste("Bearer", Sys.getenv("POPULATE_DATA_TOKEN"), sep=" "), Origin="http://madrid.gobierto.dev"))
data <- fromJSON(content(get_data, type="text"))

# Join
df <- data$data

# Write the CSV
#write.csv(df, file = "data.csv")
