library(data.table)

icd_10_codes <- icd_10_se <- data.table::fread(
  paste0("https://www.socialstyrelsen.se/globalassets",
         "/sharepoint-dokument/dokument-webb/",
         "klassifikationer-och-koder/icd-10-se.tsv")
)

icd_10_codes <- icd_10_codes[, .(title  = Titel,
                                 node   = Kod,
                                 parent = `Överordnad kod`)]
icd_10_codes[icd_10_codes == ""] <- NA
icd_10_codes <- tidyr::fill(icd_10_codes, parent, .direction = "down")
icd_10_codes <- unique(icd_10_codes, by = c("node", "parent"))
icd_10_codes <- icd_10_codes[, lapply(.SD, function(x) gsub("\\.", "", x))]

icd_10_se <- create_tree(icd_10_codes)

usethis::use_data(icd_10_se, overwrite = TRUE)
