#' Tree scan statistics for R
#'
#' @param data
#'  The dataset used for the computation
#'
#' @param exposure
#'  The name of the exposure variable
#'
#' @param p
#'  The proportion of exposed individuls in the dataset. The default is the
#'  proportion of exposed individuals among unique individuals in `data`.
#'
#' @param leafs
#'  The name of the leaf variable
#'
#' @param id
#'  The name of the id variable
#'
#' @param n_monte_carlo_sim
#'  The number of Monte Carolo simulations used for calculating P-values.
#'
#' @param n_level
#'  The number of levels of the tree. The default is the maximum character
#'  length found among the leafs.
#'
#' @param future_control
#'  A list of arguments passed to `makeCluster` for parallisation.
#'
#' @examples
#' TreeScan(diagnoses,
#'          exposure = case,
#'          leafs = diag,
#'          id = id,
#'          n_monte_carlo_sim = 10,
#'          parallel = TRUE,
#'          parallel_control = list(2))
#'
#' @import data.table
#' @export

TreeScan <- function(data,
                     exposure,
                     p = FALSE,
                     leafs,
                     id,
                     n_monte_carlo_sim = 1000,
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
  if(!p) p <- with(unique(data, by = as.character(id)),
                   sum(get(exposure) == 1) / sum(get(exposure) == 0))

  # Convert data to data.table
  data <- data.table::copy(data)
  data.table::setDT(data)

  # Set up parallel or sequential processing
  do.call(future::plan,
          future_control)

  # Estimate LLRs
  temp <- future.apply::future_lapply(
    X = seq_len(n_monte_carlo_sim),
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
                 counts[, n1 := stats::rbinom(n, 1, .1)]
                 counts[, n0 := n - n1]
               }

               calc_llr(counts, i, p = p)

             })                 |>
        data.table::rbindlist() |>
        unique() # Only keep new leafs

    }) |> data.table::rbindlist()

  # Get ranke of llr
  temp <- temp[order(llr, decreasing = TRUE),
               rank := row.names(.SD), by = "cut"]

  # Get observed llrs
  temp <- temp[iteration == 1]

  # Output
  temp[, list(cut,
              n1,
              n0,
              llr,
              p = as.numeric(rank)/(n_monte_carlo_sim + 1))]

}
