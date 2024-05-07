#' Unconditional Bernoulli Tree-Based Scan Statistics for R
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
#' @param p
#'  The proportion of exposed individuals in the dataset. Will be calculated
#'  based on `n_exposed`, and `n_unexposed` if both are supplied.
#'
#' @param n_exposed Number of exposed individuals (Optional).
#'
#' @param n_unexposed Number of unexposed individuals (Optional).
#'
#' @param dictionary
#'   A `data.frame` that includes one `node` column and a `title` column,
#'   which are used for labeling the cuts in the output of `TreeMineR`.
#'
#' @param delimiter
#'  A character defining the delimiter of different tree levels within your
#'  `pathString`. The default is `/`.
#'
#' @param n_monte_carlo_sim
#'  The number of Monte-Carlo simulations to be used for calculating P-values.
#'
#' @param random_seed Random seed used for the Monte-Carlo simulations.
#'
#' @param return_test_dist If `true`, a data.frame of the maximum log-likelihood
#'  ratios in each Monte Carlo simulation will be returned. This distribution
#'  of the maximum log-likelihood ratios is used for estimating the P-value
#'  reported in the result table.
#'
#' @param future_control
#'  A list of arguments passed `future::plan`. This is useful if one would like
#'  to parallelise the Monte-Carlo simulations to decrease the computation
#'  time. The default is a sequential run of the Monte-Carlo simulations.
#'
#' @references Kulldorff et al. (2003)
#'  A tree-based scan statistic for database disease surveillance.
#'  Biometrics 56(2): 323-331. DOI: 10.1111/1541-0420.00039.
#'
#' @examples
#' TreeMineR(data = diagnoses,
#'           tree  = icd_10_se,
#'           p = 1/11,
#'           n_monte_carlo_sim = 99,
#'           random_seed = 1234) |>
#'   head()
#'
#' @return A `data.frame` with the following columns:
#'   \describe{
#'     \item{`cut`}{The name of the cut G.}
#'     \item{`n1`}{The number of exposed events belonging to cut G.}
#'     \item{`n1`}{The number of inexposed events belonging to cut G.}
#'     \item{`risk1`}{The absolute risk of getting an event belonging to cut G
#'                    among the exposed.}
#'     \item{`risk0`}{The absolute risk of getting an event belonging to cut G
#'                    among the unexposed.}
#'     \item{`RR`}{The risk ratio of the absolute risk among the exposed over
#'                 the absolute risk among the unexposed}
#'     \item{`llr`}{The log-likelihood ratio comparing the observed and
#'                  expected number of exposed events belonging to cut G.}
#'     \item{`p`}{The P-value that cut G is a cluster of events.}}
#'
#'  If `return_test_dist`  is `true` the function returns a list of two
#'  data.frame.
#'  \describe{
#'     \item{`result_table`}{A data.frame including the results as described
#'                           above.}
#'     \item{`test_dist`}{A data.frame with two columns: `iteration` the number
#'                        of the Monte Carlo iteration. Note that iteration
#'                        is the calculation based on the original data and
#'                        is, hence, not included in this data.fame. `max_llr`:
#'                        the highest observed log-likelihood ratio for each
#'                        Monte Carlo simulation}
#'                        }
#'
#' @import data.table
#' @export TreeMineR

TreeMineR <- function(data,
                      tree,
                      p = NULL,
                      n_exposed   = NULL,
                      n_unexposed = NULL,
                      dictionary = NULL,
                      delimiter = "/",
                      n_monte_carlo_sim = 9999,
                      random_seed = FALSE,
                      return_test_dist = FALSE,
                      future_control = list(strategy = "sequential")){

  # Declare variables used in data.table for R CMD check
  n1 <- n0 <- n <- llr <- iteration <- pathString <- ..p <- id <- NULL
  risk1 <- risk0 <- RR <- ..n_exposed <- ..n_unexposed <- exposed <- NULL

  # Convert data to data.table
  data <- data.table::copy(data)
  data.table::setDT(data)

  # Assign default values if not specified -------------------------------------

  if(is.null(p) & all(!is.null(n_exposed), !is.null(n_unexposed))) {
    p <- n_exposed / sum(n_exposed, n_unexposed)

    cli::cli_inform(paste("Calculated {.code p} based on {.code n_exposed}",
                          "and {.code n_exposed}.",
                          "{.code p} is set to {round(p, 5)}."))

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

  if(!is.null(dictionary) & !all(c("title", "node") %in% colnames(dictionary))){
    cli::cli_abort(
      c(
        "x" = paste("I could not find your {.code title} and/or {.code node}",
                    "column in your dictionary.")
      )
    )
  }

  if(all(!is.null(n_exposed), !is.null(n_unexposed))){
    if(any(n_exposed <= 0, n_unexposed <= 0)){
      cli::cli_abort(
        c(
          "x" = paste("One of {.code n_exposed} and {.code n_unexposed} is",
                      "less or equal to 0."),
          "i" = paste("Both {.code n_exposed} and {.code n_unexposed}",
                      "must be greater than 0.")
        )
      )
    }
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

  # Prepare output -------------------------------------------------------------

  if(any(is.null(n_exposed), is.null(n_unexposed))){

    out <- temp[, list(cut,
                       n1,
                       n0,
                       llr,
                       p = as.numeric(rank)/(n_monte_carlo_sim + 1))]

  } else {

    # Add risks and risk rations -------------------------------------------------

    temp[, risk1 := n1/..n_exposed]
    temp[, risk0 := n0/..n_unexposed]
    temp[, RR    := risk1/risk0]

    out <- temp[, list(cut,
                       n1,
                       n0,
                       risk1,
                       risk0,
                       RR,
                       llr,
                       p = as.numeric(rank)/(n_monte_carlo_sim + 1))]

  }

  if(!is.null(dictionary)){

    # Return
    out <- merge(out,
                 dictionary,
                 by.x = "cut",
                 by.y = "node")

    data.table::setcolorder(out, c("title", "cut"))

  }

  # Order by descending llr
  data.table::setorder(out, -llr)

  if(return_test_dist){

    list(result_table = as.data.frame(out),
         test_dist    = as.data.frame(test_distribution))

  } else {

    as.data.frame(out)

  }

}
