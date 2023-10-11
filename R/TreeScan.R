#' Tree scan statistics for R
#'
#' @param data
#'  The dataset used for the computation. The dataset needs to include the
#'  following columns:
#'  \itemize{
#'    \item{An integer that is unique to every individual.}
#'    \item{A string identifying the unique diagnoses or leafs for each
#'               individual.}
#'    \item{A case indicator}
#'    }
#'
#'    The dataset needs to be in long format, i.e., each individual has
#'    multiple rows depending of unique events that occurred to the
#'    individuals, e.g.
#'
#'    ```
#'     id diag case
#'      1 K251    0
#'      2 Q702    0
#'      3  G96    0
#'      3 S949    0
#'      4 S951    0
#'      4 N882    0
#'      4 R610    0
#'      4  E67    0
#'    ```
#'
#' @param exposure
#'  The name of the exposure variable in `data`.
#'
#' @param p
#'  The proportion of exposed individuals in the dataset. The default is the
#'  proportion of exposed individuals among unique individuals in `data`.
#'
#' @param leafs
#'  The name of the leaf variable in `data`.
#'
#' @param id
#'  The name of the id variable in `data`.
#'
#' @param n_monte_carlo_sim
#'  The number of Monte-Carlo simulations to be used for calculating P-values.
#'
#' @param n_level
#'  The maximum number of character that identify a unique cut. The default
#'  is the maximum character length found in `leafs`.
#'
#' @param future_control
#'  A list of arguments passed `future::plan`. This is useful if one would like
#'  to parallelise the Monte-Carlo simulations to decrease the computation
#'  time. The default is a sequential run of the Monte-Carlo simulations.
#'
#' @examples
#' TreeScan(diagnoses,
#'          exposure = case,
#'          leafs = diag,
#'          id = id,
#'          n_monte_carlo_sim = 10)
#'
#' @import data.table
#' @export

TreeScan <- function(data,
                     exposure,
                     p = FALSE,
                     leafs,
                     id,
                     n_monte_carlo_sim = 9999,
                     random_seed = FALSE,
                     n_level = FALSE,
                     future_control = list(strategy = "sequential")){

  exposure <- substitute(exposure)
  leafs    <- substitute(leafs)
  id       <- substitute(id)

  # Decleare variables used in data.table for R CMD check
  n1 <- n0 <- n <- llr <- iteration <- NULL

  # Update n_level and p if not defined in function call
  if(!n_level) n_level <- max(nchar(data[[as.character(leafs)]]))
  if(!p) p <- unique(data, by = as.character(id))[, sum(get(..exposure)) / .N]

  # Convert data to data.table
  data <- data.table::copy(data)
  data.table::setDT(data)

  # Set up parallel or sequential processing
  do.call(future::plan,
          future_control)

  # Estimate LLRs
  temp <- future.apply::future_lapply(
    X = seq_len(1 + n_monte_carlo_sim),
    future.packages = "data.table",
    future.seed = random_seed,
    FUN = function(i){

      lapply(seq_len(n_level),
             function(j){

               counts <- get_cuts(data,
                                  id,
                                  exposure,
                                  leafs,
                                  n_char = j)

               if(i != 1){
                 counts[, n  := n0 + n1]
                 counts[, n1 := mapply(stats::rbinom, 1, n, ..p)]
                 counts[, n0 := n - n1]
               }

               calc_llr(counts, i, p = p)

             })                 |>
        data.table::rbindlist() |>
        unique() # Only keep new leafs

    }) |> data.table::rbindlist()

  # Get ranke of llr
  test_distribution <- temp[iteration != 1,
                            list(max_llr = max(llr, na.rm = TRUE)),
                            by = iteration]

  temp <- temp[iteration == 1 & !is.nan(llr)]
  temp[, rank := mapply(\(x) sum(test_distribution$max_llr > x) + 1, llr)]

  # Output
  temp[order(llr, decreasing = TRUE),
       list(cut,
            n1,
            n0,
            llr,
            p = as.numeric(rank)/(n_monte_carlo_sim + 1))]

}
