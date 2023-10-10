#' Obtaining the number of events in different cuts for `TreeScan`
#'
#' This is an internal function requiered for `TreeScan`.
#'
#' @noRd
#'
#' @param data a data.table passed to TreeScan
#'
#' @param id name of the `id` variable passed to TreeScan
#'
#' @param exposure name of the `exposure` variable passed to TreeScan
#'
#' @param leafs name of the `leafs` variable passed to TreeScan
#'
#' @param n_char the number of letters considered for the cut
#'
#' @return a data.table with the following columns
#'    \item{cut}{The name of the cut}
#'    \item{n0}{The number of events belonging to the cut among unexposed individuals}
#'    \item{n1}{The number of events belonging to the cut among exposed individuals}

get_cuts <- function(data,
                     id,
                     exposure,
                     leafs,
                     n_char){

  ..id <- ..exposure <- ..leafs <- NULL

  cuts <- data[, list(id       = get(..id),
                      exposure = get(..exposure),
                      cut      = substr(get(..leafs), 1, n_char))] |>
    unique()

  cuts  <- cuts[, list(n = .N), by = list(exposure, cut)]

  data.table::dcast(cuts, "cut ~ paste0('n', exposure)",
                    value.var = "n",
                    fill = 0)

}
