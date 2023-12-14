library(data.table)

# Downloaded from https://bioportal.bioontology.org/ontologies/ATC/?p=summary
# based on Version 2023AA
atc <- atc_raw

# Extract level 5 ATC codes
atc[, atc := gsub("^(.*)\\/(.*)", "\\2", `Class ID`)]
atc <- atc[`ATC LEVEL` == 5, .(atc)]

# Extract all parent codes of the level 5 codes (Note 1)
atc <- lapply(list(1, 3, 4, 5, 7), function(x) substr(atc$atc, 1, x)) |>
  as.data.table()

# Put level 1 codes at the end
setcolorder(atc, rev(colnames(atc)))

# Re order rows
setorder(atc, V5)

# Add no parent for level 1 codes
atc[, V0 := NA]

# Create a data set defining the ATC hirachy using node and parents
atc <- lapply(seq_len(ncol(atc) - 1), function(i){

  unique(atc[, .SD, .SDcols = c(i, i + 1)])

})      |>
  rev() |>
  rbindlist(use.names = FALSE)

colnames(atc) <- c("node", "parent")

# Add ATC as the highest level
atc[1:14, parent := "ATC"]

# Create a hirachical tree
atc_codes <- create_tree(atc)

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
