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
#' @param random_seed Random seed used for the Monte-Carlo simulations.
#'
#' @param cut_positions
#'  The character positions in the leaf variable that define a cut. The default
#'  is a cut after each character in `leafs`. E.g. the code `A17` would
#'  by default lead to the cuts `A`, `A1`, and `A17`. However, if
#'  `cut_positions = c(1, 3)` the leaf would only be cut at `A` and `A17`.
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
                     p = NULL,
                     leafs,
                     id,
                     n_monte_carlo_sim = 9999,
                     random_seed = NULL,
                     cut_positions = NULL,
                     future_control = list(strategy = "sequential")){

  # Prepare inputs for further use ---------------------------------------------
  exposure <- substitute(exposure)
  leafs    <- substitute(leafs)
  id       <- substitute(id)

  # Decleare variables used in data.table for R CMD check
  n1 <- n0 <- n <- llr <- iteration <- ..exposure <- ..p <- NULL

  # Convert data to data.table
  data <- data.table::copy(data)
  data.table::setDT(data)

  # Assign default values if not specified -------------------------------------

  # Update n_level and p if not defined in function call
  if(is.null(cut_positions)) {
    cut_positions <- seq_len(max(nchar(data[[as.character(leafs)]])))
  }

  if(is.null(p)) {
    p <- unique(data, by = as.character(id))[, sum(get(..exposure)) / .N]
  }

  # Check user input -----------------------------------------------------------
  if(max(cut_positions) > max(nchar(data[[as.character(leafs)]]))){
    x <- cut_positions[cut_positions > max(nchar(data[[as.character(leafs)]]))]

    cli::cli_abort(
      c(paste("Your cut position(s)", paste(x, collapse = ", "), "are bigger",
              " than the maximum number of characters defining a leaf."),
        " " = paste("Please specify cut positions that are smaller than the",
                    "maximum number of charcters defining a leaf."))
    )
  }

  # Run tree based scan statistic ----------------------------------------------

  # Set up parallel or sequential processing
  oplan <- do.call(future::plan,
                   future_control)
  on.exit(future::plan(oplan), add = TRUE)

  # Estimate LLRs
  temp <- future.apply::future_lapply(
    X = seq_len(1 + n_monte_carlo_sim),
    future.packages = "data.table",
    future.seed = ifelse(is.na(random_seed), FALSE, random_seed),
    FUN = function(i){

      lapply(cut_positions,
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

  # Prepare output -------------------------------------------------------------

  temp[order(llr, decreasing = TRUE),
       list(cut,
            n1,
            n0,
            llr,
            p = as.numeric(rank)/(n_monte_carlo_sim + 1))]

}
