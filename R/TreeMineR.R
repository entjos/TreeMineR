#' Tree scan statistics for R
#'
#' @param data
#'    The dataset used for the computation. The dataset needs to include the
#'    following columns:
#'
#'    \describe{
#'    \item{`id`}{An integer that is unique to every individual.}
#'    \item{`leaf`}{A string identifying the unique diagnoses or leafs for each individual.}
#'    \item{`exposed`}{A 0/1 indicator of the individual's exposure status.}
#'    }
#'    See below for the first and last rows included in the example dataset.
#'
#'    ```
#'       id leaf exposed
#'        1 K251       0
#'        2 Q702       0
#'        3  G96       0
#'        3 S949       0
#'        4 S951       0
#'     ---
#'      999 V539       1
#'      999 V625       1
#'      999 G823       1
#'     1000  L42       1
#'     1000 T524       1
#'    ```
#'
#' @param tree
#'  A dataset with one variable `pathString` defining the tree structure
#'  that you would like to use. This dataset can, e.g., be created using
#'   \code{\link{create_tree}}.
#'
#' @param delimiter
#'  A character defining the delimiter of different tree levels within your
#'  `pathString`. The default is `/`.
#'
#' @param p
#'  The proportion of exposed individuals in the dataset. The default is the
#'  proportion of exposed individuals among unique individuals in `data`
#'
#' @param n_monte_carlo_sim
#'  The number of Monte-Carlo simulations to be used for calculating P-values.
#'
#' @param random_seed Random seed used for the Monte-Carlo simulations.
#'
#' @param future_control
#'  A list of arguments passed `future::plan`. This is useful if one would like
#'  to parallelise the Monte-Carlo simulations to decrease the computation
#'  time. The default is a sequential run of the Monte-Carlo simulations.
#'
#' @examples
#' TreeMineR(data = diagnoses,
#'           tree  = icd_10_se,
#'           p = 1/11,
#'           n_monte_carlo_sim = 99,
#'           random_seed = 1234)
#'
#' @import data.table
#' @export TreeMineR

TreeMineR <- function(data,
                      tree,
                      delimiter = "/",
                      p = NULL,
                      n_monte_carlo_sim = 9999,
                      random_seed = FALSE,
                      future_control = list(strategy = "sequential")){

  # Declare variables used in data.table for R CMD check
  n1 <- n0 <- n <- llr <- iteration <- pathString <- ..p <- id <- NULL
  risk1 <- risk0 <- RR <- ..n_exposed <- ..n_unexposed <- exposed <- NULL

  # Convert data to data.table
  data <- data.table::copy(data)
  data.table::setDT(data)

  n_exposed   <- data[exposed == 1, length(unique(id))]
  n_unexposed <- data[exposed == 0, length(unique(id))]

  # Assign default values if not specified -------------------------------------

  if(is.null(p)) {
    p <- n_exposed / (n_exposed + n_unexposed)
    cli::cli_inform(c("i" = "p is set to {round(p, 5)}."))
  }

  # Check user input -----------------------------------------------------------

  if("leaf" %in% colnames(tree)) {
    cli::cli_abort(
      c(
        "x" = "{.code tree} includes a column named {.code leaf}, which
        is reserved by TreeMineR",
        "i" = "Please replace {.code leaf} with another name."
      )
    )
  }

  if(!("pathString" %in% colnames(tree))) {
    cli::cli_abort(
      c(
        "x" = "Could not find column {.code pathString} in {.code tree}",
        "i" = "Please add pathString column to {.code tree}`"
      )
    )
  }

  if(!any(grepl(delimiter, tree$pathString, fixed = TRUE))){
    cli::cli_abort(
      c(
        "x" = "I could not find any match for {delimiter} in {.code pathString}.",
        "Are you sure you defined the right delimiter in your TreeMineR call?"
      )
    )
  }

  # Get cuts -------------------------------------------------------------------

  comb <- cut_the_tree(data, tree, delimiter)

  # Run tree based scan statistic ----------------------------------------------

  # Set up parallel or sequential processing
  oplan <- do.call(future::plan,
                   future_control)
  on.exit(future::plan(oplan), add = TRUE)

  # Estimate LLRs
  temp <- future.apply::future_lapply(
    X = seq_len(1 + n_monte_carlo_sim),
    future.packages = "data.table",
    future.seed = random_seed,
    FUN = function(i){

      if(i != 1){
        comb[, n  := n0 + n1]
        comb[, n1 := mapply(stats::rbinom, 1, n, ..p)]
        comb[, n0 := n - n1]
      }

      calc_llr(comb, i, p = p)


    }) |> data.table::rbindlist()

  # Get ranke of llr
  test_distribution <- temp[iteration != 1,
                            list(max_llr = max(llr, na.rm = TRUE)),
                            by = iteration]

  temp <- temp[iteration == 1 & !is.nan(llr)]
  temp[, rank := mapply(\(x) sum(test_distribution$max_llr > x) + 1, llr)]

  # Add risks and risk rations -------------------------------------------------

  temp[, risk1 := n1/..n_exposed]
  temp[, risk0 := n0/..n_unexposed]
  temp[, RR    := risk1/risk0]

  # Prepare output -------------------------------------------------------------

  temp[order(llr, decreasing = TRUE),
       list(cut,
            n1,
            n0,
            risk1,
            risk0,
            RR,
            llr,
            p = as.numeric(rank)/(n_monte_carlo_sim + 1))]

}
