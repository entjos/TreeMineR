#' Test dataset of ICD diagnoses
#'
#' A simulated dataset of hospital diagnoses created with the help of
#' the `comorbidity` package.
#'
#' @format `diagnoses`
#' A data frame with 23,144 rows and 3 columns
#' \describe{
#'    \item{id}{Individual identifier}
#'    \item{case}{Indicator for case status}
#'    \item{diag}{An ICD-10 diagnosis code}
#' }
set.seed(1)

comp <- data.frame(id = rep(1:10000, rbinom(10000, 10, 0.2)))
comp$diag <- comorbidity::sample_diag(n = nrow(comp))
comp$case <- 0

cases <- data.frame(id = rep(1:1000, rbinom(1000, 10, 0.3)))
cases$diag <- comorbidity::sample_diag(n = nrow(cases))
cases$case <- 1

diagnoses <- rbind(comp, cases)

usethis::use_data(diagnoses, overwrite = TRUE)
