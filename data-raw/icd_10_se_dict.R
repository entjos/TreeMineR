# Script for creating icd_10_se_dict.rda
# This script is based on data from Socialstyrelsen

library(data.table)
library(stringi)

# Load ICD-10-SE documentation from Socialstyrelsen
icd_10_codes <- icd_10_se <- data.table::fread(
  paste0("https://www.socialstyrelsen.se/globalassets",
         "/sharepoint-dokument/dokument-webb/",
         "klassifikationer-och-koder/icd-10-se.tsv")
)

# Remove unnecessary information
icd_10_se_dict <- icd_10_codes[, .(title  = Titel,
                                   node   = Kod)]

# Label missing as NA
icd_10_se_dict[icd_10_se_dict == ""] <- NA

# Remove missing descriptions
icd_10_se_dict <- icd_10_se_dict[!is.na(title)]

# Remove dots in ICD-10-SE codes
icd_10_se_dict <- icd_10_se_dict[, lapply(.SD, function(x) gsub("\\.", "", x))]

# Remove special Swedish characters
icd_10_se_dict$title <- stri_trans_general(icd_10_se_dict$title,
                                           "latin-ascii")

# Add file to package
usethis::use_data(icd_10_se_dict, overwrite = TRUE)
