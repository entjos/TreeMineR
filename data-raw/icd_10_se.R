# Script for creating icd_10_se.rda
# This script is based on data from Socialstyrelsen

library(data.table)

# Load ICD-10-SE codes from SoS
icd_10_codes <- icd_10_se <- data.table::fread(
  paste0("https://www.socialstyrelsen.se/globalassets",
         "/sharepoint-dokument/dokument-webb/",
         "klassifikationer-och-koder/icd-10-se.tsv")
)

# Rename variables
icd_10_codes <- icd_10_codes[, .(node   = Kod,
                                 parent = `Överordnad kod`)]

# Replace NA codes with the code above (due to the data structure)
icd_10_codes[icd_10_codes == ""] <- NA
icd_10_codes <- tidyr::fill(icd_10_codes, parent, .direction = "down")

# Remove duplicates
icd_10_codes <- unique(icd_10_codes, by = c("node", "parent"))

# Remove dotes, e.g. Z99.2 -> Z999
icd_10_codes <- icd_10_codes[, lapply(.SD, function(x) gsub("\\.", "", x))]

# Add ICD-10-SE as highest level code
icd_10_codes[1:22, parent := "ICD-10-SE"]

# Create tree string
icd_10_se <- create_tree(icd_10_codes)

# Add data to package
usethis::use_data(icd_10_se, overwrite = TRUE)
