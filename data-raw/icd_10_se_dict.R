library(data.table)
library(stringi)

icd_10_codes <- icd_10_se <- data.table::fread(
  paste0("https://www.socialstyrelsen.se/globalassets",
         "/sharepoint-dokument/dokument-webb/",
         "klassifikationer-och-koder/icd-10-se.tsv")
)

icd_10_se_dict <- icd_10_codes[, .(title  = Titel,
                                 node   = Kod)]
icd_10_se_dict[icd_10_se_dict == ""] <- NA
icd_10_se_dict <- icd_10_se_dict[!is.na(title)]

icd_10_se_dict <- icd_10_se_dict[, lapply(.SD, function(x) gsub("\\.", "", x))]
icd_10_se_dict$title <- stri_trans_general(icd_10_se_dict$title,
                                           "latin-ascii")
usethis::use_data(icd_10_se_dict, overwrite = TRUE)
