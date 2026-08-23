#' Obtaining the number of events in different cuts for `TreeMineR`
#'
#' This is an internal function requiered for `TreeMineR`.
#'
#' @noRd
#'
#' @param data a data.table passed to TreeMineR
#'
#' @param tree a hirachical tree passed to TreeMineR
#'
#' @param delimiter a delimiter passed to TreeMineR
#'
#' @return a data.table with the following columns
#'  \describe{
#'    \item{cut}{The name of the cut}
#'    \item{n0}{The number of events belonging to the cut among unexposed individuals}
#'    \item{n1}{The number of events belonging to the cut among exposed individuals}
#'    }

cut_the_tree <- function(data,
                         tree,
                         delimiter){

  # Declare variables used in data.table for R CMD check
  exposed <- NULL

  membership <- get_cut_membership(data, tree, delimiter)

  # Calculate number of exposed and unexposed within each cut
  membership[, list(n0 = sum(exposed == 0), n1 = sum(exposed == 1)),
             by = "cut"]

}
