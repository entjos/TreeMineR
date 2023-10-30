#' Tree scan statistics for R
#'
#' @param counts
#'  A data set including the number of events among exposed and unexposed for
#'  each lead. The dataset needs to include the following columns:
#'  \itemize{
#'    \item{`leaf`}{The code defining the leaf.}
#'    \item{`n0`}{The number of events within the leaf among the unexposed.}
#'    \item{`n1`}{The number of events within the leaf among the exposed.}
#'    }
#'
#'    See below for the first and last rows included in the example dataset.
#'
#'    ```
#'    leaf n0 n1
#'    1: K251  1  0
#'    2: Q702  5  0
#'    3:  G96  3  0
#'    4: S949  2  0
#'    5: S951  2  0
#'    ---
#'    9492: T118  0  1
#'    9493: A932  0  1
#'    9494: D350  0  1
#'    9495: L410  0  1
#'    9496: T524  0  1
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
#'  proportion of exposed individuals among unique individuals in `data`.
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
#' TreeScan(diagnoses,
#'          exposure = case,
#'          leafs = diag,
#'          id = id,
#'          n_monte_carlo_sim = 10)
#'
#' @import data.table
#' @export TreeScan

TreeScan <- function(counts,
                     tree,
                     delimiter = "/",
                     p,
                     n_monte_carlo_sim = 9999,
                     random_seed = FALSE,
                     future_control = list(strategy = "sequential")){

  # Decleare variables used in data.table for R CMD check
  n1 <- n0 <- n <- llr <- iteration <- ..exposure <- ..p <- NULL

  # Check user input -----------------------------------------------------------

  if("leaf" %in% colnames(tree)) {
    cli::cli_abort(
      c(
        "x" = "`tree` includes a column named `leaf`, which is reserved by
        TreeScan.",
        "i" = "Please replace `leaf` with another name."
      )
    )
  }

  if(!("pathString" %in% colnames(tree))) {
    cli::cli_abort(
      c(
        "x" = "Could not find column `pathString` in `tree`",
        "i" = "Please add pathString column to `tree`"
      )
    )
  }

  if(!any(grepl(delimiter, tree$pathString, fixed = TRUE))){
    cli::cli_abort(
      c(
        "x" = "I could not any match for {delimiter} in `pathString`.",
        "Are you sure you defined the right delimiter in your `TreeScan` call?"
      )
    )
  }

  # Get cuts -------------------------------------------------------------------

  tree$leaf <- gsub(paste0(".*(?<=", delimiter, ")(.*)"), "\\1",
                    tree[["pathString"]],
                    perl = TRUE)

  if(any(!(counts$leaf %in% tree$leaf))) {
    cli::cli_abort(
      c(
        "x" = "The following leafs are not included on your tree:
        {(counts$leaf[!(counts$leaf %in% tree$leaf)])}",
        "i" = "All leafs must be included in your tree."
      )
    )
  }

  comb <- merge(counts,
                tree,
                by = "leaf",
                all.x = TRUE)

  comb[, cut := strsplit(pathString, delimiter, fixed = TRUE)]
  comb <- comb[, list(cut = unlist(cut)), list(n0, n1)]
  comb <- comb[, list(n0 = sum(n0), n1 = sum(n1)), by = cut]

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

  # Prepare output -------------------------------------------------------------

  temp[order(llr, decreasing = TRUE),
       list(cut,
            n1,
            n0,
            llr,
            p = as.numeric(rank)/(n_monte_carlo_sim + 1))]

}
