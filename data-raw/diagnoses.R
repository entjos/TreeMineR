#' Test dataset of ICD diagnoses
#'
#' A simulated dataset of hospital diagnoses created with the help of
#' the `comorbidity` package.
#'
#' @format `diagnoses`
#' A data frame with 23,144 rows and 3 columns
#' \describe{
#'    \item{`leaf`}{The leaf code}
#'    \item{`n0`}{The number of unexposed individuals on this leaf}
#'    \item{`n1`}{The number of exposed individuals on this leaf
#' }
#'
#' @keywords data
set.seed(1)

unexposed <- data.table::data.table(id = rep(1:10000, rbinom(10000, 10, 0.2)))
unexposed$diag <- comorbidity::sample_diag(n = nrow(unexposed))
unexposed$exposed <- 0

exposed <- data.table::data.table(id = rep(1:1000, rbinom(1000, 10, 0.3)))
exposed$diag <- comorbidity::sample_diag(n = nrow(exposed))
exposed$exposed <- 1

diagnoses <- rbind(unexposed, exposed)

# Remove codes that are not included on in the ICD-10-SE
diagnoses <- diagnoses[diagnoses$diag %in% gsub(paste0(".*(?<=\\/)(.*)"), "\\1",
                                                icd_10_se$pathString,
                                                perl = TRUE), ]

colnames(diagnoses) <- c("id", "leaf", "exposed")

usethis::use_data(diagnoses, overwrite = TRUE)
