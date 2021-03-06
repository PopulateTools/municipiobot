library(httr)
library(jsonlite)
library(dplyr)

# Get data and budget categories from the TBI API
url_budget <- "https://tbi.populate.tools/gobierto/datasets/ds-presupuestos-municipales-partida.json?sort_desc_by=date&with_metadata=true&filter_by_municipality_id=28079&filter_by_year=2016"
get_budget <- GET(url=url_budget, add_headers(Authorization=paste("Bearer", Sys.getenv("POPULATE_DATA_TOKEN"), sep=" "), Origin="http://madrid.gobierto.dev"))
budget <- fromJSON(content(get_budget, type="text"))
budget <- budget$data
budget <- filter(budget, is.na(functional_code))

url_cat <- "https://tbi.populate.tools/gobierto/collections/c-categorias-presupuestos-municipales/items.json"
get_cat <- GET(url=url_cat, add_headers(Authorization=paste("Bearer", Sys.getenv("POPULATE_DATA_TOKEN"), sep=" "), Origin="http://madrid.gobierto.dev"))
cat <- fromJSON(content(get_cat, type="text"))

# Join
df <- merge(budget, cat, by=c("area","kind", "code"))
df <- filter(df, area == 'functional') %>%
  select(municipality_id, value_per_inhabitant, name)

df$dataset <- "Gasto por habitante" 

# Write the CSV
write.csv(df, file = "output/data.csv", row.names = FALSE)
