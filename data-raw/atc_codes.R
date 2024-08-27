library(data.table)

# Downloaded from https://bioportal.bioontology.org/ontologies/ATC
# used .csv version
# based on Version 2023AB
atc <- atc_raw

# Remove codes that do not represent a drug or drug class
atc <- atc_raw[!`Preferred Label` %in% c("Entity", "Event")]

# Nodes and corresponding parents
atc[, node   := gsub("^(.*)\\/(.*)", "\\2", `Class ID`)]
atc[, parent := gsub("^(.*)\\/(.*)", "\\2", Parents)]

# Rename root from owl#Thing to ATC
atc[parent == "owl#Thing", parent := "ATC"]

# Create tree
atc_tree <- create_tree(atc[, .(node, parent)])

# Add atc_codes to package data
usethis::use_data(atc_codes, overwrite = TRUE)

#'//////////////////////////////////////////////////////////////////////////////
#' NOTES:
#' (1) ATC levels are organised as follows using the code A10BB01 as example:
#'    Level | characters   | example
#'    ------------------------------
#'    I.    |  one letter  | A
#'    II.   |  2 digits    | 01
#'    III.  |  one letter  | B
#'    IV.   |  one letter  | B
#'    V.    |  2 digits    | 01
#'    ------------------------------
#'
#'//////////////////////////////////////////////////////////////////////////////
