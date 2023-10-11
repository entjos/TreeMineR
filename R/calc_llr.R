#' Calculation of the log-likelihood ratio for `TreeScan`
#'
#' This is an internal function requiered for `TreeScan`.
#'
#' @noRd
#'
#' @param counts a data.table created with `get_cuts`
#'
#' @param no_iteration the number of the Monte-Carlo iteration
#'
#' @param p the expected proportion of unexposed individuals
#'
#' @return a data.table with the following columns
#'    \item{no_iteration}{The number of the Monte-Carlo iteration}
#'    \item{cut}{The name of the cut}
#'    \item{n0}{The number of events amogn unexposed individuals}
#'    \item{n1}{The number of events among the exposed individuals}
#'    \item{llr}{The log-likelihood ratio}

calc_llr <- function(counts, no_iteration, p){

  n0 <- n1 <- q0 <- q1 <- ll0 <- lla <- llr <- iteration <- NULL

  counts[, q1 := n1 /(n0 + n1)]
  counts[, q0 := n0 /(n0 + n1)]

  counts[, lla := log(q1) * n1 + log(q0) * n0]
  counts[, ll0 := log(p)  * n1 + log(1 - p)  * n0]
  counts[, llr := (lla - ll0) * as.numeric(q1 > p)]

  counts[, list(iteration = no_iteration, cut, n0, n1, llr)]

}
